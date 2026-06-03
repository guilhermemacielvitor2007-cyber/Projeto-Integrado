# Sprint 3 — Projeto Técnico, Diagramas e Plano de Testes

> Projeto Integrado II — Tecnologia em Análise e Desenvolvimento de Sistemas (TADS)
> Semestre 1/2026 | Professor Roberto Maia
> Empresa fictícia: VitaClínica

---

## 1. ARQUITETURA DA SOLUÇÃO

### 1.1 Infraestrutura Atual da VitaClínica

A VitaClínica opera com uma infraestrutura de TI distribuída entre duas unidades. A **Unidade Central** concentra os sistemas críticos da organização: o servidor principal do Sistema de Prontuário Eletrônico do Paciente (PEP), o servidor de banco de dados, o sistema financeiro e o servidor de arquivos de laudos e imagens médicas. A **Unidade Bairro** dispõe de um servidor local para o sistema de agendamento e acessa o PEP e o banco de dados da Unidade Central via rede VPN.

As duas unidades estão interligadas por uma VPN baseada em OpenVPN, que garante a comunicação segura entre as redes locais. Cada unidade possui seu próprio switch, firewall/roteador e estações de trabalho para uso dos colaboradores. A infraestrutura atual não conta com soluções de redundância, backup automatizado ou qualquer mecanismo formal de recuperação de desastres.

A topologia da rede é representada no diagrama a seguir:

> Ver: `evidencias/diagrama_topologia.svg`

### 1.2 Solução Proposta de Backup e Continuidade

A solução proposta para a VitaClínica é estruturada em três camadas complementares, em conformidade com a regra 3-2-1 de backup e as diretrizes do NIST SP 800-34:

**Camada 1 — Backup Local (Cópia 1):**
Instalação de um dispositivo NAS (*Network Attached Storage*) em cada unidade para armazenamento das cópias de backup locais. Os backups são realizados automaticamente por meio do Veeam Backup & Replication (edição conceitual), com incrementais a cada 1 hora para os ativos críticos e diários completos para os demais ativos.

**Camada 2 — Backup em Nuvem (Cópia 2):**
Envio automatizado das cópias de backup para o Amazon S3, utilizando criptografia AES-256 em trânsito e em repouso. O Amazon S3 oferece durabilidade de 99,999999999% (onze noves), garantindo a integridade das cópias remotas. Os dados são armazenados na região sa-east-1 (São Paulo) para conformidade com a LGPD.

**Camada 3 — Backup Off-site (Cópia 3):**
Rotação semanal de HDs externos criptografados, transportados manualmente para um local físico distante de ambas as unidades (mínimo 30 km). Cada HD é criptografado com AES-256 antes do transporte. Esta camada garante a recuperação em cenários de destruição física total de uma das unidades.

O fluxo completo da solução de backup é representado no diagrama a seguir:

> Ver: `evidencias/diagrama_fluxo_backup.svg`

### 1.3 Componentes Tecnológicos da Solução

| Componente | Função | Tecnologia / Solução |
|------------|--------|----------------------|
| Backup local automatizado | Cópia 1 da regra 3-2-1 | Veeam Backup & Replication (conceitual) |
| Armazenamento local | NAS para backups locais | Synology NAS ou equivalente |
| Backup em nuvem | Cópia 2 da regra 3-2-1 | Amazon S3 (região sa-east-1) |
| Backup off-site | Cópia 3 da regra 3-2-1 | HD externo criptografado (rotação semanal) |
| Criptografia | Proteção dos dados em backup | AES-256 (openssl / Veeam encryption) |
| Monitoramento | Alertas de falha de backup | Zabbix (conceitual) |
| Conectividade entre unidades | VPN segura | OpenVPN |
| Script de automação | Backup do servidor PEP | Shell script (ver `scripts/backup_pep.sh`) |

---

## 2. PLANO DE BACKUP DETALHADO

### 2.1 Implementação da Regra 3-2-1

A regra 3-2-1 é implementada da seguinte forma na VitaClínica:

| Cópia | Destino | Mídia | Localização | Ferramenta |
|-------|---------|-------|-------------|------------|
| Cópia 1 | NAS local de cada unidade | Disco (NAS) | On-site (cada unidade) | Veeam / rsync |
| Cópia 2 | Amazon S3 | Nuvem | Off-site remoto (nuvem) | AWS CLI / Veeam |
| Cópia 3 | HD externo criptografado | Disco externo | Off-site físico (30+ km) | Manual + openssl |

### 2.2 Política de Backup por Ativo Crítico

| ID | Ativo | Tipo de Backup | Frequência | Janela | Retenção | Prioridade |
|----|-------|---------------|------------|--------|----------|------------|
| A01 | Servidor PEP | Incremental contínuo + Full diário | Incremental: 1h / Full: 23h00 | 23h00–01h00 | 90 dias | Crítica |
| A02 | Banco de Dados de Pacientes | Snapshot incremental + Full diário | Incremental: 1h / Full: 22h00 | 22h00–00h00 | 90 dias | Crítica |
| A05 | Laudos e Imagens Médicas | Incremental diário + Full semanal | Diário: 01h00 / Semanal: dom 02h00 | 01h00–04h00 | 180 dias | Crítica |
| A03 | Sistema de Agendamento | Full diário | 23h30 | 23h30–00h30 | 60 dias | Alta |
| A04 | Sistema Financeiro | Full diário + Full mensal | Diário: 00h00 / Mensal: último dia | 00h00–02h00 | 365 dias | Alta |
| A07 | Estações de Trabalho | Full semanal | Sexta 20h00 | 20h00–23h00 | 30 dias | Média |

### 2.3 Janela de Backup

As janelas de backup foram definidas para minimizar o impacto sobre os usuários e evitar concorrência com os horários de maior uso dos sistemas. A VitaClínica opera das 07h00 às 20h00. Todos os backups completos (*full*) são agendados entre 22h00 e 04h00, quando o sistema está com carga mínima. Os backups incrementais de hora em hora dos ativos críticos (A01 e A02) são executados em segundo plano com impacto desprezível na performance dos servidores.

### 2.4 Política de Criptografia e Segurança

Todos os backups da VitaClínica devem seguir as seguintes diretrizes de segurança:

- **Criptografia em repouso:** AES-256 para todos os arquivos de backup armazenados em NAS, HD externo e Amazon S3
- **Criptografia em trânsito:** TLS 1.2 ou superior para transmissão dos backups para a nuvem
- **Gerenciamento de chaves:** As chaves de criptografia devem ser armazenadas em local separado dos backups (nunca no mesmo servidor ou NAS)
- **Controle de acesso:** Apenas os responsáveis técnicos designados têm permissão para acessar os sistemas de backup e iniciar processos de restauração
- **Integridade:** Todos os backups devem ter checksum (SHA-256) gerado automaticamente para verificação de integridade antes de qualquer restauração

### 2.5 Política de Retenção e Descarte

| Tipo de Ativo | Retenção Mínima | Retenção Máxima | Critério de Descarte |
|---------------|-----------------|-----------------|----------------------|
| Dados de saúde (PEP, laudos) | 90 dias | 180 dias | Automático após vencimento |
| Dados financeiros | 365 dias | 5 anos | Conforme legislação fiscal |
| Dados de agendamento | 60 dias | 90 dias | Automático após vencimento |
| HDs externos (off-site) | 30 dias de rotação | — | Destruição física certificada |

O descarte de mídias físicas (HDs externos) deve ser realizado por meio de destruição física certificada ou degaussing, garantindo a irrecuperabilidade dos dados, conforme boas práticas de segurança da informação (ABNT NBR ISO/IEC 27001:2013, controle A.8.3).

---

## 3. PROCEDIMENTOS DE RECUPERAÇÃO

### 3.1 Cenário 1 — Falha de Hardware (Servidor)

**Descrição do cenário:** Falha física do servidor principal da Unidade Central (queda de disco rígido, falha de placa-mãe, superaquecimento com dano irreversível), resultando na indisponibilidade do sistema PEP e do banco de dados de pacientes.

**Condições de acionamento do plano:**
- O sistema de monitoramento (Zabbix) emite alerta de servidor inacessível por mais de 5 minutos
- Usuários relatam impossibilidade de acesso ao PEP em ambas as unidades
- Tentativas de reinicialização remota do servidor não obtêm resposta

**Equipe responsável:** Responsável Técnico (Guilherme Maciel) + Apoio Técnico (Yan)

**Procedimento de resposta:**

| Etapa | Ação | Responsável | Prazo |
|-------|------|-------------|-------|
| 1 | Confirmar a natureza da falha (hardware vs. software) via acesso físico ao servidor | Guilherme | 15 min |
| 2 | Comunicar ao Líder do Sprint e à direção da clínica sobre o incidente | Filipe | 20 min |
| 3 | Ativar o servidor de contingência (hardware sobressalente pré-configurado) | Guilherme | 30 min |
| 4 | Restaurar o backup mais recente do PEP e do banco de dados a partir do NAS local | Guilherme + Yan | 60 min |
| 5 | Verificar integridade dos dados restaurados (checksum + testes funcionais) | Guilherme | 20 min |
| 6 | Redirecionar o tráfego das estações de trabalho para o servidor de contingência | Yan | 10 min |
| 7 | Comunicar às equipes das duas unidades o retorno à operação | Filipe | 5 min |
| 8 | Registrar o incidente e as ações tomadas no Registro de Incidentes | Filipe | 30 min |

**RTO alvo:** 2 horas | **RPO alvo:** máximo 1 hora de dados perdidos

**Fonte de restauração prioritária:** NAS local da Unidade Central (Cópia 1)
**Fonte alternativa:** Amazon S3 (Cópia 2), caso o NAS também esteja inacessível

---

### 3.2 Cenário 2 — Ataque de Ransomware

**Descrição do cenário:** Malware do tipo ransomware infecta a rede da VitaClínica, criptografando arquivos em servidores e estações de trabalho e exigindo pagamento de resgate para recuperação. Este cenário representa o risco de maior criticidade identificado na análise de riscos (nível 9 — Crítico).

**Condições de acionamento do plano:**
- Arquivos nos servidores ou estações passam a ter extensões desconhecidas (ex.: `.encrypted`, `.locked`)
- Aparece mensagem de resgate na tela de alguma máquina
- O Zabbix detecta aumento anormal de I/O em disco em múltiplas máquinas simultaneamente
- Usuários relatam que não conseguem abrir documentos que antes funcionavam

**Regra de ouro:** **NUNCA pagar o resgate.** O pagamento não garante a recuperação dos dados e financia organizações criminosas.

**Equipe responsável:** Responsável Técnico (Guilherme Maciel) + toda a equipe

**Procedimento de resposta:**

| Etapa | Ação | Responsável | Prazo |
|-------|------|-------------|-------|
| 1 | **ISOLAMENTO IMEDIATO:** desconectar fisicamente da rede TODAS as máquinas suspeitas (desligar o switch ou desconectar os cabos de rede) | Guilherme + Yan | 5 min |
| 2 | Desligar a VPN entre as unidades para evitar propagação à Unidade Bairro | Guilherme | 5 min |
| 3 | Identificar o ponto de entrada do ataque (e-mail de phishing, acesso remoto comprometido) e o alcance da infecção | Guilherme | 30 min |
| 4 | Comunicar o incidente à direção da clínica e, se houver vazamento de dados de pacientes, notificar a ANPD conforme o art. 48 da LGPD | Filipe | 30 min |
| 5 | Formatar e reinstalar o sistema operacional de todas as máquinas infectadas (não tentar remover o ransomware) | Guilherme + Yan | 3–4 h |
| 6 | Identificar o backup limpo mais recente (anterior à infecção) no NAS ou no Amazon S3 | Guilherme | 30 min |
| 7 | Restaurar todos os sistemas a partir do backup limpo identificado | Guilherme + Yan | 2–3 h |
| 8 | Verificar integridade dos dados restaurados e realizar testes funcionais completos | Guilherme | 1 h |
| 9 | Reconectar as máquinas à rede somente após confirmação de que estão limpas | Guilherme | 30 min |
| 10 | Alterar todas as senhas de acesso (servidores, sistemas, VPN, e-mail) | Yan | 1 h |
| 11 | Registrar o incidente em detalhe e comunicar o retorno à operação | Filipe | 1 h |

**RTO alvo:** 8 horas | **RPO alvo:** backup limpo mais recente (máx. 1 hora antes da infecção)

**Fonte de restauração prioritária:** Amazon S3 (Cópia 2) — o NAS local pode ter sido criptografado junto
**Fonte alternativa:** HD off-site (Cópia 3), se o NAS e a nuvem estiverem comprometidos

**Atenção:** Antes de restaurar a partir do NAS local, verificar se os arquivos no NAS também foram criptografados pelo ransomware. Se sim, utilizar obrigatoriamente a cópia em nuvem ou o HD off-site.

---

### 3.3 Cenário 3 — Desastre Físico (Incêndio)

**Descrição do cenário:** Incêndio em uma das unidades da VitaClínica (Unidade Central ou Unidade Bairro), resultando em destruição parcial ou total da infraestrutura física de TI da unidade afetada — servidores, NAS, estações de trabalho e demais equipamentos.

**Condições de acionamento do plano:**
- Incêndio confirmado em uma das unidades com dano a equipamentos de TI
- A unidade afetada está inacessível (interdição pela Defesa Civil ou Bombeiros)
- Perda total ou parcial dos servidores físicos e do NAS local da unidade

**Prioridade máxima:** Segurança das pessoas. Nenhum equipamento justifica risco à vida.

**Equipe responsável:** Líder do Sprint (Filipe) coordena; Responsável Técnico (Guilherme) executa a recuperação técnica

**Procedimento de resposta:**

| Etapa | Ação | Responsável | Prazo |
|-------|------|-------------|-------|
| 1 | Garantir a evacuação de todos os colaboradores e acionar o Corpo de Bombeiros (193) | Todos | Imediato |
| 2 | Comunicar o incidente à direção da clínica e às equipes de ambas as unidades | Filipe | 30 min |
| 3 | Se o incêndio for na Unidade Bairro: redirecionar todos os atendimentos para a Unidade Central | Filipe | 1 h |
| 4 | Se o incêndio for na Unidade Central: acionar modo de operação de contingência na Unidade Bairro (sistema de agendamento local, atendimentos emergenciais apenas) | Filipe | 2 h |
| 5 | Acionar o HD externo off-site correspondente à unidade afetada (localizado a 30+ km) | Guilherme | 2 h |
| 6 | Adquirir ou provisionar hardware de substituição (servidores e NAS temporários) | Filipe | 24–48 h |
| 7 | Instalar sistemas operacionais e aplicações nos novos servidores | Guilherme + Yan | 4–8 h |
| 8 | Restaurar os dados a partir do HD off-site criptografado | Guilherme | 4–8 h |
| 9 | Validar a integridade dos dados restaurados e realizar testes funcionais | Guilherme | 2 h |
| 10 | Reintegrar a unidade recuperada à rede VPN e retomar as operações normais | Guilherme | 1 h |
| 11 | Registrar o incidente, acionar seguros e providenciar laudo técnico | Filipe | Após estabilização |

**RTO alvo:** 48 horas para retomada parcial; 72 horas para retomada total
**RPO alvo:** máximo 7 dias (frequência da rotação do HD off-site)

**Fonte de restauração:** HD externo off-site (Cópia 3) + Amazon S3 (Cópia 2)

---

## 4. PLANO DE TESTES

### 4.1 Objetivos dos Testes

A realização de testes periódicos do plano de backup e do BCP/DRP é fundamental para garantir que os procedimentos documentados são executáveis na prática e que as cópias de backup são efetivamente recuperáveis. Conforme o NIST SP 800-34, um plano de contingência que nunca foi testado oferece garantias apenas teóricas e pode falhar justamente no momento crítico em que é acionado.

Os objetivos do plano de testes da VitaClínica são:
- Verificar que os backups são íntegros e restauráveis
- Validar que os procedimentos de recuperação funcionam dentro dos RTOs estabelecidos
- Identificar falhas, lacunas ou desatualizações no plano
- Treinar a equipe para que os procedimentos sejam executados com segurança e agilidade

### 4.2 Tipos de Testes

| Tipo de Teste | Descrição | Frequência | Responsável |
|---------------|-----------|------------|-------------|
| Teste de restauração de backup | Restaurar um arquivo ou banco de dados completo a partir de cada fonte de backup (NAS, S3, HD off-site) em ambiente de homologação | Mensal | Guilherme |
| Teste de integridade (checksum) | Verificar automaticamente o checksum SHA-256 dos backups gerados | Semanal (automatizado) | Script automático |
| Simulação de falha de hardware | Simular a indisponibilidade do servidor principal e executar o procedimento do Cenário 1 em ambiente controlado | Trimestral | Guilherme + Yan |
| Exercício de mesa (*tabletop exercise*) | Reunião com toda a equipe para simular verbalmente os cenários de desastre, verificando se cada membro conhece seu papel | Semestral | Filipe (facilitador) |
| Teste de recuperação completa | Restaurar todos os sistemas críticos do zero (simulando perda total de uma unidade) usando apenas as cópias de backup disponíveis | Anual | Toda a equipe |

### 4.3 Cronograma de Testes

| Teste | Jan | Fev | Mar | Abr | Mai | Jun | Jul | Ago | Set | Out | Nov | Dez |
|-------|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
| Restauração de backup | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ | ✔ |
| Checksum automático | Semanal (automatizado) |||||||||||||
| Simulação falha hardware | ✔ | | | ✔ | | | ✔ | | | ✔ | | |
| Exercício de mesa | | | ✔ | | | | | | ✔ | | | |
| Recuperação completa | | | | | | ✔ | | | | | | |

### 4.4 Critérios de Sucesso e Aceite

Um teste é considerado bem-sucedido quando todos os critérios a seguir são atendidos:

| Critério | Valor Esperado |
|----------|----------------|
| Tempo de restauração do PEP | Menor ou igual a 2 horas (RTO A01) |
| Tempo de restauração do BD de Pacientes | Menor ou igual a 2 horas (RTO A02) |
| Integridade dos dados restaurados | 100% (checksum SHA-256 validado) |
| Perda de dados (RPO verificado) | Máximo 1 hora para ativos críticos |
| Execução correta do procedimento | Sem desvios não autorizados do procedimento documentado |
| Comunicação à equipe | Todos os membros notificados dentro do prazo definido no procedimento |

Testes que não atingirem os critérios de sucesso devem gerar um **Relatório de Não Conformidade**, com identificação da causa raiz, plano de correção e prazo de reteste.

---

## Referências (parciais — serão consolidadas no relatório final)

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR ISO/IEC 27001:2013**: Tecnologia da informação — Técnicas de segurança — Sistemas de gestão da segurança da informação — Requisitos. Rio de Janeiro: ABNT, 2013.

BRASIL. **Lei nº 13.709, de 14 de agosto de 2018**. Lei Geral de Proteção de Dados Pessoais (LGPD). Brasília: Presidência da República, 2018.

NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY. **NIST Special Publication 800-34 Rev. 1**: Contingency Planning Guide for Federal Information Systems. Gaithersburg: NIST, 2010.

SÊMOLA, Marcos. **Gestão da Segurança da Informação**: uma visão executiva. 2. ed. Rio de Janeiro: Elsevier, 2014.

---

> *Documento produzido no âmbito do Sprint 3 — sujeito a revisão e complementação nas etapas subsequentes.*
