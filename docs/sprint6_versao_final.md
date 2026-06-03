# Sprint 6 — Versão Final, Conclusão e Entrega

> Projeto Integrado II — Tecnologia em Análise e Desenvolvimento de Sistemas (TADS)
> Semestre 1/2026 | Professor Roberto Maia
> Empresa fictícia: VitaClínica

---

## 1. SUMÁRIO EXECUTIVO

### 1.1 Destinatário e Propósito

Este sumário executivo foi elaborado para a Direção da VitaClínica e destina-se a apresentar, em linguagem acessível, os principais resultados do Plano de Backup e Continuidade de Negócios (BCP/DRP) desenvolvido durante o semestre. O documento completo, de caráter técnico, está organizado nos Sprints 1 a 6 e pode ser consultado pela equipe de TI conforme necessário.

### 1.2 O Problema que Este Plano Resolve

Antes deste projeto, a VitaClínica não possuía nenhum mecanismo formal de backup nem qualquer procedimento documentado para responder a falhas de sistemas ou emergências. Isso representa um risco operacional e legal significativo: a indisponibilidade de prontuários eletrônicos durante o atendimento pode comprometer a segurança dos pacientes; a perda irreversível de dados de saúde configura infração à Lei Geral de Proteção de Dados (LGPD), sujeitando a clínica a multas de até R$ 50 milhões por infração (art. 52 da LGPD).

### 1.3 O Que o Plano Entrega

O BCP/DRP da VitaClínica estabelece um conjunto de procedimentos, ferramentas e responsabilidades que garantem a continuidade das operações da clínica mesmo diante de falhas graves. Em termos práticos, o plano garante que:

| Situação | Tempo máximo para retomada |
|----------|--------------------------|
| Falha do servidor principal (hardware) | **2 horas** |
| Ataque de ransomware (criptografia de dados) | **8 horas** |
| Incêndio ou destruição física da unidade | **48 a 72 horas** |

Em todos os cenários, os dados dos pacientes são recuperados de cópias de segurança criptografadas — armazenadas simultaneamente em três locais distintos (servidor local, nuvem Amazon e HD externo a mais de 30 km da clínica) — sem necessidade de pagar resgates ou reconstruir informações manualmente.

### 1.4 Resultados do Teste Realizado

Em 02 de junho de 2026, a equipe realizou um exercício de mesa simulando a falha do servidor principal. Os resultados foram:

- **Dados recuperados:** 100% dos prontuários e registros, com menos de 47 minutos de dados pendentes (meta: até 1 hora);
- **Tempo de retomada:** 2 horas e 5 minutos (meta: 2 horas) — margem de 5 minutos acima do objetivo, causada por um detalhe de organização física já corrigido;
- **Integridade dos dados:** 100% dos arquivos restaurados passaram na verificação de segurança.

### 1.5 Obrigações Legais Cobertas

O plano atende às exigências da **Lei Geral de Proteção de Dados (LGPD)**:

- **Art. 46:** Medidas de segurança para proteção de dados de saúde — criptografia AES-256, controle de acesso e backups;
- **Art. 48:** Procedimento formal de notificação à ANPD em até 72 horas em caso de incidente — modelo de comunicação incluído no Sprint 4;
- **Art. 50:** Política de privacidade e governança — incluída neste documento (Seção 3).

### 1.6 Recomendação à Direção

Recomenda-se que a VitaClínica:

1. **Aprove a implantação formal** do plano conforme o cronograma de 8 semanas definido no Sprint 4;
2. **Designe orçamento** para a aquisição dos equipamentos especificados: 2 NAS (Synology DS223), 4 HDs externos de 4 TB e contratação do serviço de guarda off-site;
3. **Assine formalmente** o plano, conforme previsto na Fase 3 do cronograma;
4. **Autorize** a realização semestral dos exercícios de mesa com participação de um representante da direção como observador.

O investimento em continuidade é significativamente inferior ao custo de uma interrupção não planejada — seja em tempo de atendimento perdido, retrabalho de equipe, impactos à reputação ou eventuais sanções legais.

---

## 2. ENDEREÇAMENTO DO GAP G03 — PROCEDIMENTO DICOM PARA RANSOMWARE

### 2.1 Contexto

O Gap G03, identificado na análise de Sprint 5 (Seção 5.2), consiste na ausência de procedimento específico para isolamento e recuperação do sistema de laudos e imagens médicas (DICOM) em um cenário de ransomware. Este gap foi classificado como risco Médio porque o sistema DICOM possui características técnicas distintas dos demais ativos — como arquivos em formato proprietário (.dcm), software PACS (*Picture Archiving and Communication System*) com versões fixas e imagens com metadados sensíveis de pacientes embutidos — que exigem etapas de recuperação específicas além do procedimento geral do Cenário 2 (Sprint 3, Seção 3.2).

O Gap G03 é encerrado com este procedimento.

### 2.2 Características do Ativo A05 (Laudos/DICOM)

| Característica | Detalhe |
|----------------|---------|
| Formato dos arquivos | DICOM (.dcm) — padrão internacional para imagens médicas |
| Software de gestão | PACS (ex.: Orthanc, Horos, ou equivalente open-source) |
| Volume médio de dados | 2–5 GB/dia em exames (raio-X, ultrassonografia, eletrocardiograma) |
| Dados sensíveis embutidos | Nome, data de nascimento, CPF, tipo de exame, médico solicitante |
| Obrigação de retenção | Mínimo de 20 anos (CFM Resolução 2.299/2021) |
| Vetor de risco adicional | Arquivos DICOM são grandes e frequentemente excluídos de varreduras antivírus por performance |

### 2.3 Procedimento Específico — Cenário 2 × Ativo A05

Este procedimento complementa o Cenário 2 do Sprint 3 e deve ser executado pelo Responsável Técnico (Guilherme Maciel) em paralelo com as etapas gerais de resposta ao ransomware, assim que o servidor PACS for identificado como possivelmente comprometido.

#### ETAPA P1 — Detecção e Contenção Imediata (até 15 min após alerta)

| Ação | Responsável | Como verificar |
|------|-------------|----------------|
| Verificar se arquivos DICOM têm extensão modificada (ex.: `.dcm.encrypted`, `.dcm.locked`) | Guilherme | Acessar diretório de armazenamento do PACS; verificar extensões de arquivos recentes |
| Desconectar fisicamente o servidor PACS da rede (cabo de rede) | Guilherme | Retirar cabo de rede do servidor ou desativar porta no switch gerenciável |
| Desconectar todas as estações de trabalho de imagens (ultrassom, raio-X) da rede | Yan | Desconectar fisicamente ou bloquear via switch |
| Registrar hora exata da contenção no Registro de Incidente (campo "Hora de acionamento do plano") | Filipe | Formulário INC-AAAA-NNN do Sprint 4 |

> **Regra absoluta:** Nunca tentar executar o descriptografador oferecido pelo ransomware. Nunca pagar o resgate. Arquivos corrompidos devem ser descartados e substituídos pela cópia de backup.

#### ETAPA P2 — Avaliação de Dano (30 min após contenção)

| Ação | Resultado Esperado |
|------|--------------------|
| Verificar o último snapshot do NAS anterior à infecção | Identificar o ponto de recuperação mais recente com arquivos íntegros |
| Estimar volume de arquivos comprometidos vs. volume total | Determinar se a recuperação parcial (apenas exames recentes) é suficiente para o RTO |
| Verificar se arquivos da Cópia 2 (Amazon S3) estão íntegros — S3 Versioning protege contra sobrescrita | Confirmar disponibilidade do backup na nuvem |
| Registrar achados no campo "Descrição do incidente" do formulário | Dados para notificação ANPD se necessário |

#### ETAPA P3 — Recuperação do Sistema PACS (dentro do RTO de 4h para A05)

| Ordem | Ação | Responsável |
|-------|------|-------------|
| 1 | Formatar completamente o servidor PACS comprometido — nunca restaurar sobre ambiente infectado | Guilherme |
| 2 | Reinstalar o sistema operacional do servidor a partir de mídia limpa (pendrive de instalação guardado no binder físico) | Guilherme |
| 3 | Reinstalar o software PACS a partir da versão documentada no inventário de software (Sprint 4, Fase 2) | Guilherme |
| 4 | Montar o volume de restauração em diretório isolado: `mkdir /tmp/pacs_restore && mount /dev/sdX /tmp/pacs_restore` | Guilherme |
| 5 | Baixar arquivos DICOM do Amazon S3 para o diretório isolado (usar snapshot anterior à infecção): `aws s3 cp s3://vitaclinica-backups/pacs/ /tmp/pacs_restore/ --recursive` | Guilherme |
| 6 | Descriptografar os arquivos usando a chave de backup: `openssl enc -aes-256-cbc -d -pbkdf2 -iter 100000 -in arquivo.dcm.enc -out arquivo.dcm -pass file:/etc/vitaclinica/backup.key` | Guilherme |
| 7 | Executar validação de checksums SHA-256 conforme `teste_restauracao.sh` (adaptar para diretório DICOM) | Guilherme |

#### ETAPA P4 — Validação Específica de Arquivos DICOM

A validação de arquivos DICOM exige verificações além do checksum, pois um arquivo pode ter checksum válido mas conteúdo de imagem corrompido:

| Verificação | Como executar | Critério de aprovação |
|-------------|--------------|----------------------|
| Contagem de estudos restaurados | Contar arquivos `.dcm` restaurados vs. registros no banco de dados do PACS | ≥ 95% dos estudos presentes |
| Abertura de amostra de imagens | Abrir os 10 exames mais recentes no visualizador DICOM (ex.: Sante DICOM Viewer) | 10/10 legíveis e visualizáveis |
| Verificação de metadata | Confirmar que `PatientName`, `PatientID` e `StudyDate` estão corretos em amostra de 10 arquivos | 10/10 com metadata íntegro |
| Integridade visual | Verificar que nenhuma imagem apresenta artefatos ou blocos de pixels corrompidos | Avaliação visual pela equipe médica (1 médico) |

#### ETAPA P5 — Reconexão e Comunicação

O servidor PACS só deve ser reconectado à rede após:
- Limpeza total confirmada (sistema operacional reinstalado do zero);
- 100% dos arquivos de amostra validados nas verificações da Etapa P4;
- Autorização formal do Líder do Sprint (Filipe Santos).

Verificar se dados de imagens de pacientes foram acessados por terceiros. Se confirmado: notificação à ANPD em até 72 horas (LGPD art. 48) — usar modelo do Sprint 4, Seção 3.4.

### 2.4 Integração com o Fluxograma BCP

O procedimento acima deve ser executado como um ramo adicional do Cenário 2 no `diagrama_fluxo_ativacao_bcp.svg`. No Sprint 6, este gap está encerrado: o procedimento DICOM passa de **GAP** para **COBERTO** na Matriz de Análise de Gaps.

---

## 3. ENDEREÇAMENTO DO GAP G08 — POLÍTICA DE PRIVACIDADE (LGPD ART. 50)

### 3.1 Contexto

O Gap G08, identificado no Sprint 5 (Seção 5.2), corresponde à ausência de uma política formal de privacidade conforme recomendado pelo art. 50 da LGPD. O art. 50 estimula que controladores e operadores de dados adotem boas práticas de governança, incluindo a elaboração de políticas de proteção de dados e de relatórios de impacto à privacidade. Embora não seja obrigatório por lei, sua ausência representa uma lacuna de conformidade que pode ser avaliada desfavoravelmente por auditores e pela ANPD.

A política abaixo é redigida em formato resumido, adequado para publicação na intranet da VitaClínica e para apresentação a pacientes quando solicitado.

### 3.2 Política de Privacidade e Proteção de Dados — VitaClínica

---

**POLÍTICA DE PRIVACIDADE E PROTEÇÃO DE DADOS PESSOAIS**
**VitaClínica — Versão 1.0 | Junho de 2026**

**1. Identificação do Controlador**

| Campo | Informação |
|-------|-----------|
| Controlador | VitaClínica (empresa fictícia) |
| CNPJ | XX.XXX.XXX/0001-XX |
| Endereço — Unidade Central | Rua fictícia, nº XXX — Interior de São Paulo (SP) |
| Endereço — Unidade Bairro | Rua fictícia, nº XXX — Interior de São Paulo (SP) |
| Encarregado de Dados (DPO) | Filipe Oliveira Crepaldi dos Santos |
| E-mail do DPO | filipe@vitaclinica.com.br |
| Telefone do DPO | (14) 9xxxx-xxxx |

**2. Dados Pessoais Tratados**

A VitaClínica trata as seguintes categorias de dados pessoais:

| Categoria | Exemplos | Base Legal (LGPD) |
|-----------|---------|-------------------|
| Dados de identificação | Nome completo, CPF, RG, data de nascimento | Art. 7º, II (execução de contrato) |
| Dados de contato | Telefone, endereço, e-mail | Art. 7º, II (execução de contrato) |
| **Dados de saúde (sensíveis)** | Prontuário, diagnósticos, laudos, imagens, prescrições, histórico médico | Art. 11, II, f (proteção da saúde) |
| Dados financeiros | Dados de pagamento, convênio médico | Art. 7º, II (execução de contrato) |
| Dados de agendamento | Datas, horários, médico responsável | Art. 7º, II (execução de contrato) |

**3. Finalidade do Tratamento**

Os dados são tratados exclusivamente para as seguintes finalidades:

- Prestação de serviços de saúde: consultas, exames, laudos, prescrições e acompanhamento médico;
- Gestão administrativa: agendamentos, faturamento, controle de convênios;
- Cumprimento de obrigações legais: registro em prontuário (CFM), declarações fiscais, notificações compulsórias;
- Segurança da informação: backup, auditoria de acesso e proteção contra perda de dados.

Os dados de saúde **jamais serão compartilhados** para fins comerciais ou de marketing.

**4. Compartilhamento de Dados**

| Destinatário | Finalidade | Base Legal |
|--------------|-----------|-----------|
| Convênios médicos (operadoras) | Faturamento e autorização de procedimentos | Execução de contrato |
| Laboratórios e clínicas parceiras | Realização de exames solicitados | Execução de contrato |
| ANPD | Notificação de incidentes de segurança | Obrigação legal (LGPD art. 48) |
| Conselho Federal de Medicina (CFM) | Obrigações regulatórias | Obrigação legal |
| Amazon Web Services (AWS) | Armazenamento criptografado de backup | Legítimo interesse — segurança dos dados |

**5. Prazos de Retenção**

| Categoria de Dado | Prazo de Retenção | Fundamento |
|-------------------|------------------|-----------|
| Prontuário eletrônico (PEP) | 20 anos após o último atendimento | CFM Resolução 2.299/2021 |
| Imagens médicas (DICOM) | 20 anos após o último atendimento | CFM Resolução 2.299/2021 |
| Dados financeiros | 5 anos | Lei nº 9.613/1998; Código Civil art. 206 |
| Dados de agendamento | 60 dias após o atendimento | Necessidade operacional |
| Backups criptografados | 90 dias (saúde), 365 dias (financeiro) | Política interna de backup |

**6. Direitos dos Titulares**

Nos termos da LGPD (arts. 17 a 22), os pacientes têm direito a:

- **Confirmação e acesso:** saber se seus dados são tratados e receber cópia;
- **Correção:** solicitar atualização de dados incompletos ou desatualizados;
- **Eliminação:** pedir a exclusão de dados desnecessários ou tratados em desconformidade (exceto quando houver obrigação legal de guarda);
- **Portabilidade:** receber seus dados em formato estruturado para uso em outro serviço de saúde;
- **Informação:** ser informado sobre o compartilhamento com terceiros;
- **Revogação do consentimento:** quando o tratamento se basear no consentimento.

Para exercer qualquer desses direitos, o paciente deve entrar em contato com o DPO pelo e-mail `filipe@vitaclinica.com.br` ou pessoalmente em qualquer unidade da VitaClínica. O prazo de resposta é de **15 dias úteis**.

**7. Medidas de Segurança**

A VitaClínica adota as seguintes medidas técnicas e organizacionais para proteger os dados dos pacientes:

- Criptografia AES-256-CBC em todos os arquivos de backup;
- Controle de acesso baseado em perfil (somente profissionais autorizados acessam dados de saúde);
- Backups em três locais distintos (regra 3-2-1): NAS local, Amazon S3 e HD off-site;
- Verificação mensal de integridade dos backups via checksum SHA-256;
- Conexão entre unidades protegida por VPN (OpenVPN);
- Procedimento formal de resposta a incidentes (BCP/DRP — este documento);
- Treinamento da equipe em boas práticas de segurança da informação.

**8. Incidentes de Segurança**

Em caso de incidente que possa causar risco ou dano relevante aos titulares (acesso indevido, destruição ou vazamento de dados de saúde), a VitaClínica comunicará:

- A **ANPD** em prazo razoável, em conformidade com o art. 48 da LGPD e a regulamentação vigente (prazo máximo atual: **72 horas**);
- Os **titulares afetados**, de forma individual e em linguagem clara, com descrição do ocorrido e medidas adotadas.

**9. Atualizações desta Política**

Esta política será revisada anualmente ou sempre que houver alteração relevante na legislação, na infraestrutura tecnológica ou nos processos de tratamento de dados. A versão vigente estará sempre disponível na recepção das unidades e na intranet da VitaClínica.

**Versão:** 1.0 | **Data de vigência:** Junho de 2026 | **Aprovação:** Direção VitaClínica

---

---

## 4. AVALIAÇÃO FINAL DE CONFORMIDADE

### 4.1 Status Atualizado Após Sprint 6

Com o encerramento do Gap G03 (procedimento DICOM) e do Gap G08 (política de privacidade), a conformidade do projeto foi atualizada:

| Norma / Legislação | Requisitos Levantados | Atendidos (Sprint 6) | % |
|--------------------|----------------------|----------------------|---|
| Requisitos da disciplina (manual) | 7 | 7 | 100% |
| ABNT NBR ISO/IEC 27001:2013 | 7 controles avaliados | 6 | 86% |
| ABNT NBR 15999-1:2007 | 6 seções avaliadas | 5 | 83% |
| NIST SP 800-34 Rev. 1 | 7 fases | 6 | 86% |
| LGPD — Lei nº 13.709/2018 | 4 obrigações principais | 4 | 100% |

> Os itens ainda marcados como "Parcial" (testes dos Cenários 2 e 3 não realizados; Fase 7 do NIST não concluída) correspondem a atividades pós-implantação que dependem do ambiente de produção real. Não representam falhas do plano acadêmico — são etapas naturais do ciclo de maturidade após a implantação.

### 4.2 Evolução da Conformidade ao Longo do Projeto

| Sprint | Foco | Conformidade Acumulada (estimada) |
|--------|------|----------------------------------|
| Sprint 0–1 | Escopo e riscos | 20% |
| Sprint 2 | Fundamentos e requisitos | 40% |
| Sprint 3 | Projeto técnico e cenários | 65% |
| Sprint 4 | Implementação e comunicação | 73% |
| Sprint 5 | Resultados e análise de gaps | 78% |
| **Sprint 6** | **Gaps G03/G08 encerrados** | **~85%** |

> Os 15% restantes correspondem a testes reais dos Cenários 2 e 3 (dependem de implantação formal) e revisão anual pós-operação. Atingir 100% exigiria de 12 a 18 meses de operação real do plano.

---

## 5. REFERÊNCIAS BIBLIOGRÁFICAS COMPLETAS (ABNT NBR 6023)

As referências abaixo seguem o padrão **ABNT NBR 6023:2018** — Informação e documentação — Referências — Elaboração. As obras estão ordenadas em ordem alfabética de entrada.

---

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR ISO/IEC 27001:2013**: Tecnologia da informação — Técnicas de segurança — Sistemas de gestão da segurança da informação — Requisitos. Rio de Janeiro: ABNT, 2013.

---

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR 15999-1:2007**: Gestão de continuidade de negócios — Parte 1: Código de prática. Rio de Janeiro: ABNT, 2007.

---

BRASIL. **Lei nº 13.709, de 14 de agosto de 2018**. Dispõe sobre a proteção de dados pessoais e altera a Lei nº 12.965, de 23 de abril de 2014 (Marco Civil da Internet). Brasília, DF: Presidência da República, 2018. Disponível em: https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm. Acesso em: 03 jun. 2026.

---

CONSELHO FEDERAL DE MEDICINA. **Resolução CFM nº 2.299, de 30 de setembro de 2021**. Dispõe sobre a emissão de documentos médicos eletrônicos e o uso de assinatura e certificação digitais, revogando a Resolução CFM nº 1.638/2002. Brasília, DF: CFM, 2021.

---

LYRA, Maurício Rocha. **Segurança e Auditoria em Sistemas de Informação**. Rio de Janeiro: Ciência Moderna, 2008.

---

NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY. **NIST Special Publication 800-34 Rev. 1**: Contingency Planning Guide for Federal Information Systems. Gaithersburg: NIST, 2010. Disponível em: https://csrc.nist.gov/publications/detail/sp/800-34/rev-1/final. Acesso em: 03 jun. 2026.

---

SÊMOLA, Marcos. **Gestão da Segurança da Informação**: uma visão executiva. 2. ed. Rio de Janeiro: Elsevier, 2014.

---

---

## 6. CONCLUSÃO FINAL DO PROJETO

### 6.1 O que foi construído

Ao longo de seis sprints quinzenais, o grupo desenvolveu um Plano de Backup e Continuidade de Negócios (BCP/DRP) completo para a VitaClínica — uma clínica médica fictícia de médio porte com duas unidades no interior de São Paulo. O trabalho resultou nos seguintes entregáveis:

| Tipo | Qtd. | Artefatos |
|------|------|-----------|
| Documentos técnicos (.md) | 7 | plano_inicial, sprint1 a sprint6 |
| Diagramas SVG | 3 | topologia, fluxo de backup, fluxo de ativação BCP, matriz de gaps |
| Scripts de automação | 2 | backup_pep.sh, teste_restauracao.sh |
| Ferramentas HTML interativas | 2 | guia_resposta_incidentes.html, apresentacao_slides.html |

O projeto atende integralmente ao escopo definido no manual da disciplina: plano de backup com regra 3-2-1, BCP cobrindo três cenários de desastre, RPO e RTO definidos para seis ativos críticos, e relatório no padrão ABNT.

### 6.2 O que foi aprendido

Os principais aprendizados técnicos e metodológicos do projeto foram:

1. **RPO e RTO devem ser definidos antes das ferramentas**, não o contrário. Esse princípio orientou todas as decisões técnicas do Sprint 3 e resultou em escolhas justificadas objetivamente.

2. **Um plano não testado não é um plano.** O exercício de mesa do Sprint 4 revelou dois gaps que a simples leitura dos documentos não identificaria — validando a importância dos testes periódicos previstos no plano.

3. **A LGPD transforma o BCP em obrigação legal no setor de saúde.** Dados de saúde são dados sensíveis; a ausência de plano de resposta a incidentes equivale a um risco regulatório concreto.

4. **Automação reduz erro humano.** O script `teste_restauracao.sh` remove a subjetividade da verificação mensal de integridade dos backups, garantindo consistência independente de quem executa o teste.

5. **Documentação viva é mais útil do que documentação estática.** O `guia_resposta_incidentes.html` — com checklists interativos, cronômetro e modo de incidente — representa uma evolução em relação a documentos estáticos, tornando o plano utilizável em situações de estresse real.

### 6.3 Limitações e Premissas

Por tratar-se de projeto acadêmico, o BCP/DRP da VitaClínica possui as seguintes limitações:

- **Ambiente fictício:** Todos os IPs, credenciais, CNPJs e números de contato são fictícios e devem ser substituídos pelos dados reais antes da implantação;
- **Ferramentas conceituais:** Zabbix e Veeam Backup foram referenciados como ferramentas de monitoramento e backup, mas não foram instalados nem configurados em ambiente real;
- **RPO/RTO simulados:** Os valores obtidos no exercício de mesa são estimativas; os valores reais só serão conhecidos após a implantação formal e os primeiros testes técnicos;
- **Cenários 2 e 3 não testados:** Apenas o Cenário 1 (falha de hardware) foi validado via exercício de mesa. Os Cenários 2 (ransomware) e 3 (incêndio) permanecem como "documentados, aguardando teste", conforme o calendário de melhoria contínua do Sprint 5.

### 6.4 Nível de Maturidade Final

O BCP/DRP da VitaClínica encerra este projeto no **Nível 3 — Definido** da escala de maturidade de continuidade de negócios (adaptada do CMMI):

| Nível | Descrição | Status da VitaClínica |
|-------|-----------|----------------------|
| 1 — Inicial | Sem plano; resposta ad hoc a incidentes | Situação antes do projeto |
| 2 — Repetível | Procedimentos básicos existem, mas não estão formalizados | — |
| **3 — Definido** | **Plano documentado, comunicado e testado parcialmente** | **✅ Alcançado** |
| 4 — Gerenciado | Métricas históricas coletadas; testes regulares de todos os cenários | Após 12 meses de operação |
| 5 — Otimizado | Melhoria contínua baseada em dados; automação avançada | Objetivo de longo prazo |

A progressão para o **Nível 4** depende da implantação formal em julho de 2026 e da execução do calendário de melhoria contínua definido no Sprint 5. O plano fornece todas as ferramentas, scripts, formulários e procedimentos necessários para essa evolução.

### 6.5 Encerramento

Este projeto demonstra que é possível — com metodologia adequada, trabalho em equipe e documentação cuidadosa — estruturar um Plano de Backup e Continuidade de Negócios robusto e conformante com as principais normas técnicas e legislações vigentes no Brasil. O BCP/DRP da VitaClínica está pronto para implantação.

---

## Referências (neste documento)

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR ISO/IEC 27001:2013**: Tecnologia da informação — Técnicas de segurança — Sistemas de gestão da segurança da informação. Rio de Janeiro: ABNT, 2013.

BRASIL. **Lei nº 13.709, de 14 de agosto de 2018**. Lei Geral de Proteção de Dados Pessoais (LGPD). Brasília: Presidência da República, 2018.

NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY. **NIST Special Publication 800-34 Rev. 1**: Contingency Planning Guide for Federal Information Systems. Gaithersburg: NIST, 2010.

SÊMOLA, Marcos. **Gestão da Segurança da Informação**: uma visão executiva. 2. ed. Rio de Janeiro: Elsevier, 2014.

---

> *Sprint 6 — Versão Final. Projeto Integrado II concluído.*
> *Todos os sprints (0–6) estão documentados no repositório.*
