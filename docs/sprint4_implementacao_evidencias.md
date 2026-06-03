# Sprint 4 — Implementação Parcial, Evidências e Ferramentas de Apoio

> Projeto Integrado II — Tecnologia em Análise e Desenvolvimento de Sistemas (TADS)
> Semestre 1/2026 | Professor Roberto Maia
> Empresa fictícia: VitaClínica

---

## 1. CRONOGRAMA DE IMPLANTAÇÃO

### 1.1 Visão Geral

A implantação do Plano de Backup e do BCP/DRP na VitaClínica está estruturada em três fases sequenciais, com duração total estimada de oito semanas. A divisão em fases garante que cada etapa seja concluída e validada antes de dar início à seguinte, minimizando riscos durante a transição do ambiente atual — sem qualquer mecanismo de backup ou continuidade — para o ambiente proposto neste projeto.

As atividades foram distribuídas entre os membros da equipe conforme suas áreas de responsabilidade, com o Responsável Técnico (Guilherme Maciel) liderando todas as tarefas de configuração e o Líder do Sprint (Filipe Santos) coordenando a comunicação, o cronograma e a documentação.

### 1.2 Fase 1 — Pré-Implantação (Semanas 1 e 2)

Esta fase concentra as atividades preparatórias necessárias antes de qualquer instalação de software ou hardware. Nenhum sistema de produção é alterado nesta fase.

| Semana | Atividade | Responsável | Entregável |
|--------|-----------|-------------|------------|
| 1 | Aquisição do NAS (modelo Synology DS223 ou equivalente) para cada unidade | Filipe (gestão) | 2 NAS adquiridos |
| 1 | Aquisição de 4 HDs externos de 4 TB para rotação off-site (2 por unidade) | Filipe (gestão) | 4 HDs adquiridos |
| 1 | Criação da conta AWS, configuração do bucket S3 `vitaclinica-backups` na região sa-east-1 | Guilherme | Bucket S3 criado e configurado |
| 1 | Definição e contratação do local off-site para guarda dos HDs externos (mínimo 30 km) | Filipe | Contrato de guarda assinado |
| 2 | Geração e armazenamento seguro das chaves de criptografia AES-256 | Guilherme | Arquivo `backup.key` criado e guardado em local seguro separado |
| 2 | Configuração das políticas de ciclo de vida no S3 (transição para S3 Glacier após 90 dias) | Guilherme | Política S3 Lifecycle ativa |
| 2 | Documentação do inventário físico atualizado de todos os servidores e NAS | Yan | Inventário atualizado no repositório |
| 2 | Comunicação ao corpo clínico sobre o projeto e as janelas de manutenção previstas | Filipe | E-mail de comunicação enviado |

### 1.3 Fase 2 — Implantação (Semanas 3 a 6)

Esta fase abrange a instalação e configuração de todos os componentes técnicos da solução. As atividades são realizadas nas janelas noturnas para evitar impacto ao atendimento clínico.

| Semana | Atividade | Responsável | Entregável |
|--------|-----------|-------------|------------|
| 3 | Instalação física e configuração do NAS na Unidade Central | Guilherme + Yan | NAS Unidade Central operacional |
| 3 | Instalação física e configuração do NAS na Unidade Bairro | Guilherme + Yan | NAS Unidade Bairro operacional |
| 3 | Configuração do compartilhamento de rede e permissões de acesso nos dois NAS | Guilherme | Compartilhamentos configurados e testados |
| 4 | Deploy e configuração do script `backup_pep.sh` no servidor PEP | Guilherme | Script em produção, logs verificados |
| 4 | Configuração do cron para execução automática do backup (incremental: a cada hora / full: 22h00) | Guilherme | Cron ativo, primeiro backup full concluído |
| 4 | Configuração da integração do script com Amazon S3 (credenciais AWS CLI, testes de upload) | Guilherme | Upload para S3 validado com sucesso |
| 5 | Configuração dos alertas de falha de backup no Zabbix (host vitaclinica-pep, chave backup.status) | Guilherme + Yan | Alertas Zabbix ativos |
| 5 | Primeira execução da Cópia 3: backup completo no HD off-site e transporte ao local definido | Guilherme + Yan | HD off-site com cópia inicial |
| 5 | Configuração do backup dos demais ativos (A03, A04, A05, A07) conforme política do Sprint 3 | Guilherme | Jobs de backup configurados para todos os ativos |
| 6 | Treinamento da equipe: apresentação dos procedimentos dos 3 cenários de desastre | Filipe | Ata de treinamento registrada |
| 6 | Impressão e distribuição do Guia Rápido de Resposta a Incidentes para todos os responsáveis | Bruno | Cópias físicas distribuídas |
| 6 | Atualização da documentação com os parâmetros reais de configuração (IPs, paths, credenciais) | Yan | Documentação atualizada |

### 1.4 Fase 3 — Pós-Implantação e Validação (Semanas 7 e 8)

Fase de validação e entrega formal do plano. Nenhuma nova instalação é realizada; o foco é comprovar o funcionamento e oficializar o documento.

| Semana | Atividade | Responsável | Entregável |
|--------|-----------|-------------|------------|
| 7 | Execução do primeiro teste de restauração completo (Cenário 1 — ver Seção 4) | Guilherme + Filipe | Relatório de teste assinado |
| 7 | Validação dos RTOs e RPOs na prática com base no teste realizado | Guilherme | RTO/RPO verificados ou ajustados |
| 7 | Execução do script `teste_restauracao.sh` e verificação dos logs gerados | Guilherme | Relatório de integridade gerado |
| 8 | Revisão final do plano com toda a equipe e incorporação das lições aprendidas | Filipe | Plano revisado e aprovado |
| 8 | Assinatura do plano pela direção da VitaClínica | Filipe | Plano assinado e arquivado |
| 8 | Publicação do Guia HTML de Resposta a Incidentes nos servidores internos | Yan | Guia disponível na intranet |

---

## 2. MATRIZ DE RESPONSABILIDADES (RACI)

### 2.1 Legenda da Matriz RACI

A metodologia RACI é amplamente utilizada para definir com clareza os papéis e as responsabilidades de cada membro da equipe em relação a cada atividade ou decisão. Os quatro papéis são:

| Papel | Descrição |
|-------|-----------|
| **R — Responsável** (*Responsible*) | Quem executa a atividade. Pode haver mais de um responsável por atividade. |
| **A — Aprovador** (*Accountable*) | Quem tem autoridade final sobre a atividade e responde pelo resultado. Deve ser apenas um por atividade. |
| **C — Consultado** (*Consulted*) | Quem deve ser consultado antes ou durante a execução. Contribui com informações ou orientações. |
| **I — Informado** (*Informed*) | Quem deve ser notificado sobre o progresso ou o resultado, sem participar diretamente da execução. |

### 2.2 Matriz RACI por Atividade

| Atividade | Filipe (Líder) | Guilherme (Técnico) | Yan (Apoio Técnico) | Bruno (Documentação) | Rafael (Evidências) | Direção |
|-----------|:--------------:|:-------------------:|:-------------------:|:--------------------:|:-------------------:|:-------:|
| Detectar e reportar anomalia | I | A | R | I | I | I |
| Ativar formalmente o BCP/DRP | A/R | C | I | I | I | I |
| Isolar a rede (cenário ransomware) | C | A/R | R | I | I | I |
| Executar restauração de backup — NAS | I | A/R | R | — | I | I |
| Executar restauração de backup — Amazon S3 | I | A/R | R | — | I | I |
| Executar restauração de backup — HD off-site | C | A/R | R | — | I | I |
| Verificar integridade dos dados restaurados | I | A/R | C | — | R | I |
| Comunicar incidente à equipe interna | A/R | I | I | I | I | I |
| Notificar ANPD (LGPD, art. 48) | A/R | C | — | — | — | C |
| Comunicar pacientes afetados | A/R | I | — | — | — | C |
| Registrar incidente no formulário oficial | A/R | C | — | — | R | I |
| Realizar rotação semanal do HD off-site | I | A | R | — | — | — |
| Executar teste mensal de restauração | I | A/R | R | — | R | I |
| Conduzir exercício de mesa semestral | A/R | C | C | C | C | I |
| Revisar e atualizar o plano anualmente | A/R | C | — | R | C | I |

---

## 3. PLANO DE COMUNICAÇÃO DE INCIDENTES

### 3.1 Objetivos do Plano de Comunicação

O plano de comunicação de incidentes define quem deve ser notificado, em que ordem e de que forma, quando o BCP/DRP da VitaClínica for acionado. A comunicação eficiente durante um incidente é tão crítica quanto a execução técnica da recuperação: falhas de comunicação podem atrasar decisões, gerar pânico desnecessário ou resultar no descumprimento de obrigações legais — como a notificação à ANPD exigida pela LGPD.

### 3.2 Árvore de Escalada

A notificação deve seguir a ordem de escalada definida abaixo, com os prazos máximos indicados a partir da detecção do incidente:

```
[DETECÇÃO DO INCIDENTE]
         |
         | até 10 min
         ↓
[NÍVEL 1 — Equipe Técnica]
  Guilherme Maciel (Responsável Técnico)
  Yan (Apoio Técnico)
  → Avaliam gravidade e iniciam contenção
         |
         | até 20 min
         ↓
[NÍVEL 2 — Liderança]
  Filipe Santos (Líder do Sprint)
  → Coordena ações, aciona níveis 3 e 4 conforme necessário
         |
    _____|_____
   |           |
   | até 30 min|  se houver vazamento de dados de saúde
   ↓           ↓
[NÍVEL 3]   [NÍVEL 4 — Obrigação LGPD]
  Direção      ANPD — prazo máximo: 72 horas (art. 48)
  VitaClínica  Titulares dos dados afetados
```

### 3.3 Tabela de Contatos de Emergência

| Nome | Cargo | Telefone Principal | Telefone Alternativo | E-mail |
|------|----|-------------------|---------------------|--------|
| Guilherme Maciel | Responsável Técnico | (14) 9xxxx-xxxx | (14) 9xxxx-xxxx | guilherme@vitaclinica.com.br |
| Filipe Santos | Líder do Sprint | (14) 9xxxx-xxxx | (14) 9xxxx-xxxx | filipe@vitaclinica.com.br |
| Yan | Apoio Técnico | (14) 9xxxx-xxxx | — | yan@vitaclinica.com.br |
| Bruno Vila | Documentação | (14) 9xxxx-xxxx | — | bruno@vitaclinica.com.br |
| Rafael | Evidências | (14) 9xxxx-xxxx | — | rafael@vitaclinica.com.br |
| Direção VitaClínica | — | (14) 3xxx-xxxx | (14) 9xxxx-xxxx | direcao@vitaclinica.com.br |
| Suporte AWS | Fornecedor nuvem | 0800 xxx xxxx | — | aws.amazon.com/support |
| Corpo de Bombeiros | Emergência | 193 | — | — |
| ANPD | Autoridade | gov.br/anpd | — | comunicado@anpd.gov.br |

> **Nota:** Os números e e-mails desta tabela são fictícios e devem ser substituídos pelos dados reais no momento da implantação.

### 3.4 Modelo de Notificação à ANPD (LGPD, art. 48)

O artigo 48 da LGPD exige que o controlador de dados — no caso, a VitaClínica — comunique à Autoridade Nacional de Proteção de Dados (ANPD) e aos titulares dos dados a ocorrência de incidentes de segurança que possam acarretar risco ou dano relevante a eles, em prazo razoável, conforme regulamento da ANPD (prazo máximo atual: 72 horas após o conhecimento do incidente).

O modelo a seguir deve ser preenchido pelo Líder do Sprint (Filipe Santos) sempre que houver vazamento, acesso indevido ou destruição de dados de pacientes:

---

**COMUNICAÇÃO DE INCIDENTE DE SEGURANÇA — LGPD ART. 48**

| Campo | Informação |
|-------|-----------|
| **Controlador** | VitaClínica — CNPJ: XX.XXX.XXX/0001-XX |
| **Data/hora do incidente** | DD/MM/AAAA — HH:MM |
| **Data/hora da descoberta** | DD/MM/AAAA — HH:MM |
| **Data/hora desta comunicação** | DD/MM/AAAA — HH:MM |
| **Natureza dos dados afetados** | Dados de saúde (dados sensíveis — LGPD art. 5º, II) |
| **Categorias de titulares afetados** | Pacientes da VitaClínica |
| **Número estimado de titulares** | __________ |
| **Descrição do incidente** | *(descrever o que ocorreu, como foi detectado e o que foi comprometido)* |
| **Medidas adotadas** | *(descrever as ações imediatas tomadas para conter o incidente)* |
| **Risco residual** | *(descrever se ainda existe risco e quais medidas adicionais serão tomadas)* |
| **Contato do encarregado (DPO)** | Filipe Santos — filipe@vitaclinica.com.br |

---

### 3.5 Comunicação com os Pacientes

Nos casos em que dados de saúde de pacientes tenham sido comprometidos (acessados, destruídos ou vazados por terceiros não autorizados), a VitaClínica deve notificar individualmente os titulares afetados, por e-mail ou carta, contendo no mínimo:

- Descrição do que ocorreu em linguagem clara e acessível
- Dados que foram afetados
- Medidas tomadas pela clínica para proteger os dados e evitar novos incidentes
- Canal de atendimento para dúvidas dos pacientes (telefone ou e-mail do responsável)

---

## 4. SIMULAÇÃO DE TESTE CONCEITUAL

### 4.1 Dados do Exercício

Esta seção registra a execução de um **exercício de mesa** (*tabletop exercise*) conduzido com toda a equipe do projeto, em conformidade com o tipo de teste semestral definido no Plano de Testes do Sprint 3. O exercício de mesa é uma simulação verbal e documentada, sem manipulação de sistemas de produção, cujo objetivo é verificar se todos os membros da equipe conhecem seus papéis e se o plano está completo e executável.

| Item | Detalhe |
|------|---------|
| **Data de realização** | 02 de junho de 2026 |
| **Horário** | 09h00 às 11h00 |
| **Local** | Sala de reuniões — VitaClínica Unidade Central (simulado) |
| **Tipo de teste** | Exercício de mesa (*tabletop exercise*) |
| **Cenário simulado** | Cenário 1 — Falha de Hardware (servidor principal da Unidade Central) |
| **Facilitador** | Filipe Santos |
| **Participantes** | Guilherme Maciel, Yan, Bruno Vila, Rafael |
| **Documento de referência** | Sprint 3 — Seção 3.1 (Procedimento do Cenário 1) |

### 4.2 Descrição do Cenário Simulado

O facilitador apresentou a seguinte situação hipotética no início do exercício:

> *"São 14h32 de uma segunda-feira. O Zabbix emite alertas consecutivos informando que o servidor principal da Unidade Central está inacessível há mais de 5 minutos. As estações de trabalho das duas unidades exibem erros ao tentar abrir o PEP e o sistema de banco de dados de pacientes não responde. Há 47 pacientes agendados para o período da tarde, dos quais 12 já estão na recepção aguardando atendimento. Nenhuma cópia impressa dos prontuários está disponível nas unidades."*

Cada participante foi solicitado a descrever verbalmente suas ações conforme o procedimento documentado, e o facilitador registrou o tempo estimado para cada etapa e eventuais desvios.

### 4.3 Registro de Execução do Exercício

| Etapa | Ação Esperada (conforme Sprint 3) | Resposta da Equipe | Tempo Estimado | Desvio? | Observação |
|-------|-----------------------------------|--------------------|---------------|---------|------------|
| 1 | Confirmar a natureza da falha via acesso físico ao servidor | Guilherme descreveu o acesso à sala de servidores e a identificação de falha em disco (RAID degradado, LED vermelho) | 12 min | Não | Execução dentro do esperado |
| 2 | Comunicar ao Líder do Sprint e à direção da clínica | Filipe notificou a direção verbalmente e registrou o horário da comunicação | 8 min | Não | Comunicação ágil e correta |
| 3 | Ativar o servidor de contingência (hardware sobressalente) | Guilherme identificou que o documento com a configuração IP do servidor de contingência não estava imediatamente acessível — foi necessário consultar o repositório do projeto | 32 min | **Sim (+7 min)** | Documentação de configuração não estava impressa no binder físico |
| 4 | Restaurar o backup mais recente a partir do NAS local | Guilherme e Yan descreveram o processo de mount do NAS, localização do snapshot mais recente e execução da restauração | 45 min | Não | RPO verificado: 47 min de dados pendentes (< meta de 1h) |
| 5 | Verificar integridade dos dados restaurados | Guilherme descreveu a validação do checksum SHA-256 e testes de abertura de prontuários | 14 min | Não | 100% dos checksums conferidos |
| 6 | Redirecionar tráfego das estações para servidor de contingência | Yan descreveu a atualização das entradas DNS internas e teste em uma estação de trabalho | 9 min | Não | Procedimento claro e executado corretamente |
| 7 | Comunicar às equipes o retorno à operação | Filipe notificou recepção e médicos das duas unidades; pacientes em espera foram informados pela recepção | 5 min | Não | Comunicação aos pacientes foi improvisada; falta script de comunicação |
| 8 | Registrar o incidente | Filipe iniciou o preenchimento do Registro de Incidente durante o exercício | 27 min | **Sim (+7 min)** | Primeiro preenchimento do formulário levou mais tempo por ser exercício inaugural |

**Tempo total de execução (etapas 1 a 7, excluindo registro):** 125 minutos = **2h05min**

> **Nota:** O tempo total excedeu marginalmente o RTO de 2 horas em razão dos dois desvios identificados. O tempo da etapa 8 (registro) foi contabilizado separadamente, pois pode ser iniciado em paralelo com a etapa 7 e concluído após a retomada das operações.

### 4.4 Desvios Identificados e Plano de Correção

| Desvio | Etapa | Impacto | Ação Corretiva | Prazo |
|--------|-------|---------|----------------|-------|
| Documentação de configuração do servidor de contingência não disponível em formato físico | 3 | +7 min no RTO | Incluir ficha de configuração dos servidores no binder físico de incidentes, impresso e plastificado, nas duas unidades | Antes da implantação (Fase 3) |
| Ausência de script de comunicação para pacientes em espera | 7 | Comunicação improvisada | Criar modelo de comunicação rápida para recepção: texto padrão para informar pacientes sobre incidente e tempo estimado de retomada | Sprint 5 |

### 4.5 Resultado e Conclusão

O exercício de mesa foi considerado **parcialmente bem-sucedido**. Os critérios principais do plano foram atendidos:

- **RPO verificado:** 47 minutos de dados pendentes — dentro da meta de 1 hora ✔
- **RTO estimado:** 2h05min — margem de 5 minutos acima da meta, causada por desvios corrigíveis ≈ ✔
- **Integridade dos dados:** 100% dos checksums validados ✔
- **Comunicação interna:** Todos os membros notificados conforme o plano ✔
- **Conhecimento da equipe:** Todos os participantes demonstraram conhecer seus papéis no procedimento ✔

Os dois desvios identificados são de baixa complexidade e possuem plano de correção definido. Nenhum deles compromete a viabilidade do plano. O teste será repetido após a implantação formal, conforme o cronograma de testes do Sprint 3.

---

## 5. FORMULÁRIOS DE REGISTRO

### 5.1 Modelo de Registro de Incidente

Este formulário deve ser preenchido pelo Líder do Sprint (Filipe Santos) em todo incidente que acione o BCP/DRP, independentemente do cenário. O original deve ser arquivado fisicamente nas duas unidades; cópia digital deve ser mantida no repositório do projeto.

---

**REGISTRO DE INCIDENTE — VitaClínica**

| Campo | Preenchimento |
|-------|--------------|
| **Número do incidente** | INC-AAAA-NNN |
| **Data e hora de abertura** | ___/___/______ — ____h____ |
| **Responsável pelo registro** | |
| **Cenário acionado** | ☐ Cenário 1 — Falha de Hardware  ☐ Cenário 2 — Ransomware  ☐ Cenário 3 — Incêndio  ☐ Outro |
| **Descrição do incidente** | |
| **Ativos afetados** | ☐ A01 — PEP  ☐ A02 — BD Pacientes  ☐ A03 — Agendamento  ☐ A04 — Financeiro  ☐ A05 — Laudos  ☐ A06 — VPN  ☐ Outros: __________ |
| **Ponto de origem identificado** | |
| **Hora de acionamento do plano** | ____h____ |
| **Hora de início da restauração** | ____h____ |
| **Fonte de restauração utilizada** | ☐ NAS local (Cópia 1)  ☐ Amazon S3 (Cópia 2)  ☐ HD off-site (Cópia 3) |
| **Hora de retomada das operações** | ____h____ |
| **RTO realizado** | ____h ____min |
| **RPO verificado (dados perdidos)** | ____h ____min |
| **Dados de pacientes comprometidos?** | ☐ Sim — Notificação ANPD obrigatória (72h)  ☐ Não |
| **Medidas tomadas** | |
| **Lições aprendidas** | |
| **Assinatura do responsável** | _____________________________ Data: ___/___/______ |

---

### 5.2 Modelo de Relatório de Não Conformidade em Teste

Este formulário deve ser preenchido sempre que um teste periódico (restauração mensal, simulação trimestral ou exercício de mesa) não atingir os critérios de sucesso definidos no Sprint 3.

---

**RELATÓRIO DE NÃO CONFORMIDADE — VitaClínica**

| Campo | Preenchimento |
|-------|--------------|
| **Número do relatório** | RNC-AAAA-NNN |
| **Data do teste** | ___/___/______ |
| **Tipo de teste realizado** | ☐ Restauração mensal  ☐ Simulação hardware trimestral  ☐ Exercício de mesa  ☐ Recuperação completa anual |
| **Critério não atendido** | |
| **Valor esperado** | |
| **Valor obtido** | |
| **Análise de causa raiz** | |
| **Impacto no plano** | ☐ Baixo — Não compromete o RTO/RPO  ☐ Médio — Pode comprometer em situação real  ☐ Alto — Compromete o plano; revisão urgente necessária |
| **Plano de correção** | |
| **Prazo para correção** | ___/___/______ |
| **Responsável pela correção** | |
| **Data de reteste previsto** | ___/___/______ |
| **Assinatura do facilitador** | _____________________________ Data: ___/___/______ |

---

## Referências (parciais — serão consolidadas no relatório final)

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR ISO/IEC 27001:2013**: Tecnologia da informação — Técnicas de segurança — Sistemas de gestão da segurança da informação — Requisitos. Rio de Janeiro: ABNT, 2013.

BRASIL. **Lei nº 13.709, de 14 de agosto de 2018**. Lei Geral de Proteção de Dados Pessoais (LGPD). Brasília: Presidência da República, 2018.

NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY. **NIST Special Publication 800-34 Rev. 1**: Contingency Planning Guide for Federal Information Systems. Gaithersburg: NIST, 2010.

SÊMOLA, Marcos. **Gestão da Segurança da Informação**: uma visão executiva. 2. ed. Rio de Janeiro: Elsevier, 2014.

---

> *Documento produzido no âmbito do Sprint 4 — sujeito a revisão e complementação nas etapas subsequentes.*
