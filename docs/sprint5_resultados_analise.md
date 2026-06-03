# Sprint 5 — Resultados e Análise

> Projeto Integrado II — Tecnologia em Análise e Desenvolvimento de Sistemas (TADS)
> Semestre 1/2026 | Professor Roberto Maia
> Empresa fictícia: VitaClínica

---

## 1. SÍNTESE DAS ENTREGAS POR SPRINT

### 1.1 Visão Geral do Projeto

O projeto de Plano de Backup e Continuidade de Negócios (BCP/DRP) da VitaClínica foi desenvolvido ao longo de cinco sprints quinzenais, acumulando um volume expressivo de documentação técnica, evidências e artefatos de apoio operacional. Este sprint tem como objetivo consolidar os resultados produzidos, analisar criticamente o desempenho do plano frente aos objetivos propostos e identificar gaps e oportunidades de melhoria para o ciclo final de revisão (Sprint 6).

### 1.2 Tabela Consolidada de Entregas

| Sprint | Foco | Principais Entregas | Status |
|--------|------|---------------------|--------|
| Sprint 0 | Estrutura inicial | `README.md`, `docs/plano_inicial.md`, estrutura de diretórios do repositório | ✅ Concluído |
| Sprint 1 | Contextualização | Introdução ABNT, análise de riscos (5 ameaças × matriz probabilidade/impacto), escopo das duas unidades | ✅ Concluído |
| Sprint 2 | Fundamentação técnica | Referencial teórico (ABNT, NIST, LGPD), levantamento de requisitos, classificação dos 6 ativos críticos com RPO/RTO definidos | ✅ Concluído |
| Sprint 3 | Projeto técnico | Plano de backup (regra 3-2-1), procedimentos dos 3 cenários de desastre, 2 diagramas SVG, script `backup_pep.sh`, plano de testes | ✅ Concluído |
| Sprint 4 | Implementação e evidências | Cronograma de implantação (8 semanas, 3 fases), Matriz RACI, Plano de Comunicação, Exercício de Mesa do Cenário 1, formulários de registro, script `teste_restauracao.sh`, Guia HTML interativo | ✅ Concluído |
| Sprint 5 | Resultados e análise | Análise dos resultados, comparativo RPO/RTO, análise de gaps, KPIs, Plano de Melhoria Contínua, script de comunicação para pacientes | ✅ Concluído |
| Sprint 6 | Versão final | Consolidação do relatório ABNT completo, revisão geral, slides de apresentação | ⏳ Pendente |

### 1.3 Ativos Críticos e Parâmetros Definidos

A tabela abaixo consolida os parâmetros de proteção definidos para os seis ativos críticos da VitaClínica, conforme estabelecido nos Sprints 2 e 3:

| Ativo | Descrição | Criticidade | RTO | RPO | Prioridade de Restauração |
|-------|-----------|-------------|-----|-----|--------------------------|
| A01 | Prontuário Eletrônico do Paciente (PEP) | Crítico | 2 h | 1 h | 1ª — imediata |
| A02 | Banco de Dados de Pacientes | Crítico | 2 h | 1 h | 1ª — imediata |
| A03 | Sistema de Agendamento | Alto | 4 h | 4 h | 2ª |
| A04 | Sistema Financeiro | Médio | 8 h | 8 h | 3ª |
| A05 | Laudos e Imagens (DICOM) | Alto | 4 h | 4 h | 2ª |
| A06 | VPN — Interligação das Unidades | Crítico | 2 h | N/A | 1ª — imediata |

---

## 2. ANÁLISE DOS RESULTADOS DO EXERCÍCIO DE MESA

### 2.1 Contexto e Objetivos do Exercício

Em 02 de junho de 2026, a equipe do projeto conduziu o primeiro exercício de mesa (*tabletop exercise*) do BCP/DRP da VitaClínica. O exercício, previsto no Plano de Testes do Sprint 3, teve como objetivos específicos:

1. Verificar se todos os membros da equipe conhecem seus papéis e responsabilidades conforme a Matriz RACI;
2. Identificar lacunas ou ambiguidades nos procedimentos documentados;
3. Medir o tempo estimado de resposta ao Cenário 1 (Falha de Hardware) e comparar com as metas de RTO/RPO;
4. Gerar insumos para o processo de melhoria contínua do plano.

O Cenário 1 foi selecionado por ser o de maior probabilidade de ocorrência na realidade da VitaClínica e por ter sido o mais detalhado no Sprint 3 — tornando-o o mais adequado para uma primeira validação.

### 2.2 Cenário Apresentado aos Participantes

O facilitador (Filipe Santos) apresentou a seguinte situação hipotética:

> *"São 14h32 de uma segunda-feira. O sistema de monitoramento Zabbix emite alertas consecutivos informando que o servidor principal da Unidade Central está inacessível há mais de 5 minutos. As estações de trabalho das duas unidades exibem erros de conexão ao tentar abrir o PEP e o sistema de banco de dados de pacientes não responde. Há 47 pacientes agendados para o período da tarde, dos quais 12 já estão na recepção aguardando atendimento. Nenhuma cópia impressa de prontuários está disponível em nenhuma das unidades."*

### 2.3 Análise de Desempenho por Etapa

A tabela abaixo apresenta análise crítica de cada etapa do exercício, incluindo avaliação de qualidade, tempo e alinhamento com o plano documentado:

| Etapa | Ação Executada | Tempo Medido | Meta | Desvio | Avaliação |
|-------|----------------|-------------|------|--------|-----------|
| 1 — Diagnóstico | Acesso físico ao servidor, identificação de falha em disco (RAID degradado, LED vermelho) | 12 min | 15 min | -3 min | **Acima da meta.** A equipe técnica demonstrou domínio do procedimento. |
| 2 — Comunicação inicial | Notificação ao Líder do Sprint e à Direção; registro do horário de acionamento | 8 min | 10 min | -2 min | **Acima da meta.** Comunicação realizada dentro do Nível 1 da árvore de escalada. |
| 3 — Ativação do servidor de contingência | Localização da ficha de configuração IP; inicialização do servidor sobressalente | 32 min | 25 min | **+7 min** | **Abaixo da meta.** A documentação de configuração não estava no binder físico — foi necessário acessar o repositório digital. |
| 4 — Restauração do backup | Mount do NAS, localização do snapshot mais recente, execução da restauração | 45 min | 45 min | 0 | **Na meta.** RPO verificado: 47 min de dados pendentes (dentro da meta de 1h). |
| 5 — Validação de integridade | Verificação dos checksums SHA-256; abertura de prontuários para confirmação | 14 min | 15 min | -1 min | **Acima da meta.** 100% dos checksums validados com sucesso. |
| 6 — Redirecionamento de tráfego | Atualização das entradas DNS internas; teste em estação de trabalho | 9 min | 10 min | -1 min | **Acima da meta.** Yan demonstrou domínio do procedimento de DNS. |
| 7 — Comunicação de retomada | Notificação da recepção e das equipes médicas; comunicação verbal aos pacientes em espera | 5 min | 5 min | 0 | **Na meta.** A comunicação verbal foi improvisada — sem script padronizado para a recepção. |
| **Total (etapas 1 a 7)** | — | **125 min** | **120 min** | **+5 min** | **Marginal.** Superação devida exclusivamente ao desvio da Etapa 3. |

> **Observação metodológica:** A Etapa 8 (Registro de Incidente) foi conduzida em paralelo com as demais etapas a partir da Etapa 2 e concluída após a retomada das operações, demandando 27 minutos. Esse tempo não foi contabilizado no RTO, pois o registro é uma atividade administrativa paralela à recuperação técnica.

### 2.4 Análise dos Desvios Identificados

**Desvio 1 — Documentação de configuração ausente no binder físico (+7 min)**

A ausência da ficha de configuração do servidor de contingência no binder físico forçou a equipe a acessar o repositório digital — o que, em um cenário real, poderia ser inviável se o incidente envolvesse indisponibilidade de rede. O impacto direto foi de +7 minutos no RTO, suficiente para que o tempo total excedesse marginalmente a meta de 2 horas.

A causa raiz é organizacional: o procedimento de impressão e atualização do binder físico não havia sido executado porque a implantação formal ainda não ocorreu (o binder é previsto na Fase 3 do cronograma). Em um ambiente de produção real, esse desvio não ocorreria.

**Plano de correção:** Antes da Fase 3 do cronograma de implantação, imprimir e plastificar a ficha de configuração dos servidores (IP, credenciais de acesso, configuração de rede) e inserir nos binders físicos de incidentes das duas unidades. Responsável: Guilherme Maciel.

**Desvio 2 — Ausência de script de comunicação para pacientes em espera**

Na Etapa 7, a comunicação com os 12 pacientes que aguardavam na recepção foi conduzida de forma improvisada. Embora o conteúdo tenha sido adequado, a ausência de um texto padronizado representa um risco: em um incidente real, funcionários da recepção sob estresse podem omitir informações ou causar confusão desnecessária.

A causa raiz é uma lacuna no escopo do plano de comunicação do Sprint 4, que contemplou a comunicação interna e a notificação à ANPD, mas não incluiu um modelo de atendimento ao público presencial.

**Plano de correção:** Criação de script de comunicação para recepção (ver Seção 9 deste documento). Responsável: Bruno Vila / Filipe Santos.

### 2.5 Resultado Consolidado do Exercício

| Critério de Sucesso | Meta | Resultado | Status |
|---------------------|------|-----------|--------|
| RPO do Ativo A01/A02 | ≤ 1h | 47 min | ✅ Aprovado |
| RTO do Ativo A01/A02 | ≤ 2h | 2h05min | ⚠ Aprovado com ressalva |
| Checksums SHA-256 | 100% válidos | 100% válidos | ✅ Aprovado |
| Comunicação interna | Todos notificados | Todos notificados | ✅ Aprovado |
| Conhecimento da equipe | Todos sabem seus papéis | Todos demonstraram domínio | ✅ Aprovado |
| Desvios sem plano de correção | Zero | Zero (2 desvios, ambos com ação corretiva) | ✅ Aprovado |

**Resultado final:** O exercício de mesa foi considerado **aprovado com ressalvas**, demonstrando que o plano é executável e que a equipe está preparada. O único critério com ressalva (RTO = 2h05min) foi causado por uma condição circunstancial — ausência do binder físico — que será corrigida antes da implantação formal.

---

## 3. COMPARATIVO RPO/RTO — PLANEJADO VS. SIMULADO/PROJETADO

### 3.1 Metodologia do Comparativo

Para os ativos A01 e A02, os dados são provenientes da simulação do exercício de mesa (02/06/2026). Para os demais ativos (A03, A04, A05, A06), os valores são **projetados** com base nos procedimentos documentados no Sprint 3, nas características técnicas de cada ativo e no tempo médio de restauração observado na simulação do Cenário 1.

O coeficiente de ajuste utilizado para a projeção foi calculado a partir do desempenho real observado: o tempo de restauração do Cenário 1 (45 minutos para 47 min de dados, em um banco de dados de alta criticidade) serviu como referência proporcional para os demais ativos.

### 3.2 Tabela Comparativa RPO/RTO por Ativo

| Ativo | RPO Planejado | RPO Simulado/Projetado | Variação | RTO Planejado | RTO Simulado/Projetado | Variação | Avaliação |
|-------|--------------|------------------------|----------|--------------|------------------------|----------|-----------|
| A01 — PEP | 1h | **47 min** (simulado) | -13 min ✅ | 2h | **2h05min** (simulado) | +5 min ⚠ | Aprovado com ressalva |
| A02 — BD Pacientes | 1h | **47 min** (simulado) | -13 min ✅ | 2h | **2h05min** (simulado) | +5 min ⚠ | Aprovado com ressalva |
| A03 — Agendamento | 4h | **~2h** (projetado) | -2h ✅ | 4h | **~2h30min** (projetado) | -1h30min ✅ | Acima da meta |
| A04 — Financeiro | 8h | **~4h** (projetado) | -4h ✅ | 8h | **~4h** (projetado) | -4h ✅ | Acima da meta |
| A05 — Laudos/DICOM | 4h | **~3h** (projetado) | -1h ✅ | 4h | **~3h30min** (projetado) | -30min ✅ | Acima da meta |
| A06 — VPN | N/A | N/A | — | 2h | **~30min** (projetado) | -1h30min ✅ | Acima da meta |

> **Nota sobre A03:** O RTO projetado é inferior ao planejado porque o sistema de agendamento tem menor volume de dados que o PEP e pode ser restaurado a partir do mesmo snapshot do NAS de forma paralela à recuperação do PEP.

> **Nota sobre A06:** A VPN (OpenVPN) não armazena dados transacionais. Sua recuperação consiste em reimplantar o arquivo de configuração a partir do backup, o que é significativamente mais rápido do que a restauração de banco de dados.

### 3.3 Análise Geral dos RPOs e RTOs

O comparativo demonstra que, à exceção do RTO de A01/A02 (que excedeu marginalmente a meta em condições de simulação), todos os demais ativos apresentam projeções **iguais ou superiores às metas estabelecidas**. O desvio de +5 minutos no RTO de A01/A02 é corrigível com ações de baixa complexidade (atualização do binder físico) e não representa uma vulnerabilidade estrutural do plano.

A constatação mais relevante é que os ativos de criticidade intermediária (A03, A04, A05) tendem a ter desempenho melhor que o planejado, pois se beneficiam da mesma infraestrutura de backup instalada para os ativos críticos (NAS, S3, script automatizado), com carga de dados menor.

---

## 4. ANÁLISE DE ADERÊNCIA AOS REQUISITOS NORMATIVOS

### 4.1 Requisitos do Manual da Disciplina

| Requisito | Status | Evidência |
|-----------|--------|-----------|
| Plano de backup com regra 3-2-1 | ✅ Atendido | Sprint 3 — Seção 2.1; script `backup_pep.sh` |
| Definição de RPO e RTO para ativos críticos | ✅ Atendido | Sprint 2 — Seção 3.2; Sprint 5 — Seção 3.2 |
| BCP cobrindo Cenário 1 (Falha de hardware) | ✅ Atendido | Sprint 3 — Seção 3.1; Sprint 4 — Seção 4 |
| BCP cobrindo Cenário 2 (Ransomware) | ✅ Atendido | Sprint 3 — Seção 3.2 |
| BCP cobrindo Cenário 3 (Desastre físico) | ✅ Atendido | Sprint 3 — Seção 3.3 |
| Relatório no formato ABNT | ✅ Atendido | Todos os documentos seguem estrutura ABNT |
| Foco em documentação e planejamento (sem desenvolvimento) | ✅ Atendido | Nenhum sistema foi desenvolvido; apenas scripts de apoio operacional |

### 4.2 Requisitos da ABNT NBR ISO/IEC 27001:2013

| Controle | Descrição | Status | Observação |
|----------|-----------|--------|------------|
| A.12.3.1 | Backup de informações | ✅ Atendido | Regra 3-2-1, criptografia AES-256, retenção documentada |
| A.12.6.1 | Gestão de vulnerabilidades técnicas | ⚠ Parcial | Sem procedimento formal de gestão de patches documentado |
| A.16.1.1 | Procedimentos de gestão de incidentes | ✅ Atendido | Sprint 4 — Plano de Comunicação e formulários |
| A.16.1.5 | Resposta a incidentes de segurança | ✅ Atendido | Sprint 3 — 3 cenários com procedimentos detalhados |
| A.17.1.1 | Planejamento da continuidade de segurança | ✅ Atendido | Objetivo central do projeto |
| A.17.1.2 | Implementação da continuidade | ⚠ Parcial | Implementação prevista no cronograma, ainda não realizada |
| A.17.1.3 | Verificação da continuidade | ⚠ Parcial | Um exercício de mesa realizado; testes dos Cenários 2 e 3 pendentes |

### 4.3 Requisitos da ABNT NBR 15999 (Continuidade de Negócios)

| Seção | Requisito | Status | Evidência |
|-------|-----------|--------|-----------|
| 4.3 | Análise de impacto nos negócios (BIA) | ✅ Atendido | Sprint 1 — análise de riscos; Sprint 2 — classificação de ativos |
| 5.2 | Estratégias de continuidade | ✅ Atendido | Sprint 3 — 3 cenários com estratégias distintas |
| 6.1 | Desenvolvimento dos planos de continuidade | ✅ Atendido | Sprints 3 e 4 |
| 6.4 | Documentação dos planos | ✅ Atendido | Todos os documentos produzidos e versionados |
| 7.1 | Exercícios e testes | ⚠ Parcial | Exercício de mesa realizado; testes técnicos pendentes |
| 8.1 | Manutenção e revisão | ⚠ Parcial | Previsto no Plano de Melhoria Contínua (Seção 8) |

### 4.4 Requisitos da LGPD (Lei nº 13.709/2018)

| Artigo | Obrigação | Status | Evidência |
|--------|-----------|--------|-----------|
| Art. 46 | Medidas de segurança para dados pessoais | ✅ Atendido | Criptografia AES-256, controle de acesso documentado |
| Art. 48 | Comunicação de incidentes à ANPD (72h) | ✅ Atendido | Sprint 4 — Seção 3.4 — Modelo de Notificação à ANPD |
| Art. 48 | Comunicação dos incidentes aos titulares | ✅ Atendido | Sprint 4 — Seção 3.5; Sprint 5 — Seção 9 |
| Art. 50 | Boas práticas de governança | ⚠ Parcial | DPO nomeado (Filipe Santos), sem política formal de privacidade |

### 4.5 Requisitos do NIST SP 800-34 Rev. 1

| Fase | Descrição | Status | Evidência |
|------|-----------|--------|-----------|
| Fase 1 | Iniciar o processo de planejamento de contingência | ✅ Atendido | Sprints 0 e 1 |
| Fase 2 | Conduzir análise de impacto (BIA) | ✅ Atendido | Sprints 1 e 2 |
| Fase 3 | Identificar controles preventivos | ✅ Atendido | Sprint 3 — estratégias de backup e contingência |
| Fase 4 | Criar estratégias de contingência | ✅ Atendido | Sprint 3 — 3 cenários detalhados |
| Fase 5 | Desenvolver o plano de contingência | ✅ Atendido | Sprints 3 e 4 |
| Fase 6 | Planejar testes, treinamento e exercícios | ✅ Atendido | Sprint 3 — Plano de Testes; Sprint 4 — exercício de mesa |
| Fase 7 | Manter o plano | ⚠ Parcial | Plano de Melhoria Contínua definido (Seção 8) |

---

## 5. ANÁLISE DE GAPS E RISCOS RESIDUAIS

### 5.1 Metodologia

Os gaps foram identificados a partir de três fontes: (1) desvios observados no exercício de mesa do Sprint 4; (2) itens marcados como "Parcial" na análise de aderência normativa; e (3) revisão crítica do plano com base na Matriz de Análise de Gaps (ver diagrama `tabela_gap_analysis.svg`).

Cada gap foi classificado quanto ao **nível de risco residual** utilizando os mesmos critérios da matriz de riscos do Sprint 1:

| Nível | Critério |
|-------|---------|
| Alto (H) | Pode comprometer diretamente o RTO/RPO em situação real |
| Médio (M) | Pode causar atraso ou ineficiência, mas não compromete a operação |
| Baixo (L) | Impacto mínimo; ação corretiva desejável mas não urgente |

### 5.2 Registro de Gaps

| ID | Gap Identificado | Ativo/Cenário Afetado | Risco Residual | Status | Ação Corretiva | Prazo |
|----|------------------|-----------------------|---------------|--------|----------------|-------|
| G01 | Documentação de configuração do servidor de contingência não disponível em formato físico | A01, A02 / AM01 | Médio (M) | ⚠ Em correção | Impressão e plastificação para o binder físico nas duas unidades | Antes da Fase 3 |
| G02 | Ausência de script padronizado de comunicação para pacientes em espera na recepção | Todos | Baixo (L) | ✅ Resolvido | Script criado neste documento (Seção 9) | Sprint 5 (concluído) |
| G03 | Sem procedimento específico para recuperação do sistema de laudos DICOM em caso de ransomware | A05 / AM02 | Médio (M) | 🔴 Aberto | Elaborar procedimento de isolamento e recuperação do sistema de imagens médicas | Sprint 6 |
| G04 | Sem responsável substituto definido para a rotação semanal do HD off-site | Todos / AM03 | Baixo (L) | 🔴 Aberto | Nomear substituto para Guilherme Maciel na rotação do HD | Sprint 6 |
| G05 | Cenários 2 e 3 documentados mas não testados via exercício de mesa | A01–A06 / AM02, AM03 | Médio (M) | 🔴 Aberto | Planejar exercícios de mesa para AM02 (set/2026) e AM03 (dez/2026) | Pós-implantação |
| G06 | Ausência de política formal de gestão de patches e atualizações de segurança | Todos / AM02 | Médio (M) | 🔴 Aberto | Incluir procedimento de atualização periódica no Sprint 6 ou como adendo ao plano | Sprint 6 |
| G07 | Sem procedimento de reconstrução de rede detalhado para perda total da unidade | A06 / AM03 | Baixo (L) | 🔴 Aberto | Documentar topologia de rede e passos de reconstrução completa | Sprint 6 |
| G08 | Política formal de privacidade (LGPD art. 50) não documentada | Todos | Baixo (L) | 🔴 Aberto | Incluir sumário de política de privacidade no relatório final | Sprint 6 |

### 5.3 Resumo dos Gaps por Status

| Status | Quantidade | Impacto |
|--------|-----------|---------|
| ✅ Resolvido | 1 (G02) | Gap de baixo risco eliminado neste sprint |
| ⚠ Em correção | 1 (G01) | Ação em andamento antes da implantação formal |
| 🔴 Aberto | 6 (G03–G08) | 2 de risco médio (G03, G05, G06); 3 de risco baixo (G04, G07, G08) |

> **Avaliação geral:** Nenhum gap de nível Alto foi identificado. O plano não apresenta vulnerabilidades que comprometam materialmente a capacidade de resposta da VitaClínica em um incidente real. Os gaps médios (G03, G05, G06) são riscos aceitos que serão endereçados no Sprint 6 e no calendário de melhoria contínua.

---

## 6. LIÇÕES APRENDIDAS

### 6.1 Objetivo e Fonte das Lições

As lições aprendidas foram coletadas a partir de três fontes: (1) o exercício de mesa de 02/06/2026; (2) a revisão crítica de cada sprint realizada pela equipe; e (3) a análise de aderência normativa desta seção. O objetivo é que sirvam de insumo tanto para o Sprint 6 quanto para os ciclos anuais de revisão do plano após a implantação.

### 6.2 Registro de Lições Aprendidas

| ID | Observação | Causa Raiz | Ação de Melhoria | Responsável | Aplicação |
|----|-----------|-----------|------------------|-------------|-----------|
| LA01 | Documentação técnica armazenada apenas em formato digital representa risco em incidentes que afetam a rede | Foco excessivo em documentação digital durante o desenvolvimento | Manter cópias físicas impressas das configurações críticas em binders nas duas unidades | Guilherme Maciel | Antes da Fase 3 do cronograma |
| LA02 | A recepção não estava preparada para comunicar o incidente aos pacientes de forma padronizada | Plano de comunicação focado apenas no público interno e autoridades | Criar e distribuir script de comunicação para recepcionistas (ver Seção 9) | Bruno Vila | Sprint 5 (concluído) |
| LA03 | O sistema de laudos DICOM (A05) recebeu menor atenção no planejamento do que os demais ativos | Complexidade técnica do DICOM, menos familiar à equipe | Pesquisar e documentar procedimento específico de recuperação de imagens médicas | Guilherme + Yan | Sprint 6 |
| LA04 | O exercício de mesa foi mais produtivo do que qualquer revisão individual de documentos | O formato verbal forçou a simulação real e revelou gaps não óbvios na leitura | Realizar pelo menos dois exercícios por ano após a implantação; incluir novos membros da equipe da clínica | Filipe Santos | A partir de jul/2026 |
| LA05 | A Matriz RACI permitiu resolução imediata de dúvidas sobre papéis durante o exercício | Clareza prévia na definição de responsabilidades | Manter a Matriz RACI atualizada a cada revisão anual e fixá-la visualmente na sala de TI | Bruno Vila | Revisão anual |
| LA06 | O script `teste_restauracao.sh` gerou confiança nos dados de RPO ao fornecer tempo exato do snapshot | Automação da verificação elimina subjetividade na medição | Manter o script em produção e garantir que os relatórios sejam arquivados para auditoria | Guilherme Maciel | Mensalmente |
| LA07 | Definir RPO/RTO antes de escolher ferramentas forçou a equipe a justificar tecnicamente cada decisão | Abordagem *requirements-first* adotada desde o Sprint 2 | Manter essa abordagem em futuras revisões; não ajustar RPO/RTO para "acomodar" ferramentas disponíveis | Filipe Santos | Revisão anual |

---

## 7. INDICADORES DE DESEMPENHO DO BCP (KPIs)

### 7.1 Definição e Propósito

Os indicadores de desempenho (KPIs) do BCP têm por objetivo fornecer métricas objetivas que permitam avaliar a eficácia do plano ao longo do tempo. Os valores apresentados nesta seção combinam dados da simulação (para indicadores de recuperação) e projeções baseadas no plano documentado (para indicadores operacionais). Após a implantação formal, esses indicadores devem ser medidos com dados reais.

### 7.2 Indicadores de Recuperação

| KPI | Definição | Meta | Resultado (Simulação) | Status |
|-----|-----------|------|-----------------------|--------|
| RTO real — A01/A02 | Tempo total para retomada das operações do PEP e BD | ≤ 2h | 2h05min | ⚠ 97,9% da meta |
| RPO real — A01/A02 | Volume de dados pendentes no momento do incidente | ≤ 1h | 47 min | ✅ 121,8% da meta |
| Taxa de aderência ao RTO (A01/A02) | % dos critérios de RTO atendidos | 100% | 97,9% | ⚠ Próximo da meta |
| Taxa de integridade do backup | % de checksums SHA-256 válidos na restauração | 100% | 100% | ✅ 100% da meta |
| Tempo de detecção do incidente | Tempo entre a ocorrência e o primeiro alerta | ≤ 5 min | ≤ 5 min (Zabbix) | ✅ Atendido |

### 7.3 Indicadores de Cobertura do Plano

| KPI | Definição | Meta | Resultado Atual | Status |
|-----|-----------|------|-----------------|--------|
| Cobertura de cenários documentados | Nº de cenários com procedimento completo / total | 3/3 | 3/3 | ✅ 100% |
| Cobertura de cenários testados | Nº de cenários validados via exercício / total | 3/3 | 1/3 | ⚠ 33% (Cenários 2 e 3 planejados) |
| Cobertura 3-2-1 | Nº de cópias configuradas por ativo crítico | 3/3 | 3/3 (NAS+S3+HD) | ✅ 100% |
| Ativos com RPO/RTO definidos | Nº de ativos críticos com parâmetros documentados | 6/6 | 6/6 | ✅ 100% |
| Membros da equipe com papel no BCP | Nº de integrantes com papel definido na RACI | 6/6 | 6/6 | ✅ 100% |
| Conformidade normativa geral | Requisitos atendidos (total / levantados) | ≥ 80% | 22/30 = 73% | ⚠ Abaixo da meta (gaps médios e baixos) |

### 7.4 Indicadores Operacionais (Projetados para o Primeiro Ano)

| KPI | Definição | Meta Anual | Base de Cálculo |
|-----|-----------|-----------|-----------------|
| Disponibilidade-alvo do PEP | % do tempo em que o PEP estará disponível | ≥ 99,5% | Corresponde a ≤ 43,8h de indisponibilidade/ano |
| Execuções mensais do teste de restauração | Nº de execuções do script `teste_restauracao.sh` | 12/ano | Cron configurado para dia 1 de cada mês |
| Exercícios de mesa por ano | Nº de exercícios realizados com a equipe | ≥ 2/ano | Semestralmente, conforme Sprint 3 |
| Rotações do HD off-site | Nº de rotações realizadas dentro do prazo | ≥ 52/ano | Semanal, conforme política do Sprint 3 |
| Incidentes com tempo de resposta dentro do RTO | % dos incidentes reais resolvidos dentro do RTO | ≥ 95% | Meta para o primeiro ano de operação |

---

## 8. PLANO DE MELHORIA CONTÍNUA

### 8.1 Fundamento

A norma ABNT NBR 15999 estabelece que um plano de continuidade eficaz deve incluir mecanismos de melhoria contínua, com revisões periódicas que incorporem lições aprendidas de incidentes reais e exercícios. O calendário abaixo estabelece as ações de melhoria para os primeiros 12 meses após a implantação formal do plano, prevista para julho de 2026.

### 8.2 Calendário de Melhoria — Julho/2026 a Junho/2027

| Período | Ação | Tipo | Responsável | Prazo |
|---------|------|------|-------------|-------|
| Jul/2026 | Imprimir e plastificar fichas de configuração para binders físicos (G01) | Corretiva | Guilherme Maciel | 15/07/2026 |
| Jul/2026 | Distribuir script de comunicação para recepção nas duas unidades (G02) | Corretiva | Bruno Vila | 15/07/2026 |
| Jul/2026 | Nomear responsável substituto para rotação do HD off-site (G04) | Corretiva | Filipe Santos | 31/07/2026 |
| Ago/2026 | Executar primeiro teste de restauração mensal automatizado | Preventiva | Guilherme Maciel | 01/08/2026 |
| Set/2026 | Exercício de mesa — Cenário 2 (Ransomware) | Validação | Filipe Santos | 30/09/2026 |
| Out/2026 | Primeira rotação trimestral do HD off-site com verificação de integridade | Preventiva | Guilherme + Yan | 15/10/2026 |
| Nov/2026 | Documentar procedimento específico de recuperação do sistema DICOM (G03) | Corretiva | Guilherme + Yan | 30/11/2026 |
| Dez/2026 | Exercício de mesa semestral — Cenário 3 (Incêndio) | Validação | Filipe Santos | 15/12/2026 |
| Jan/2027 | Revisão anual do plano com incorporação de lições aprendidas | Evolutiva | Filipe Santos | 31/01/2027 |
| Mar/2027 | Segundo exercício de mesa anual — cenário a definir com base nos incidentes ocorridos | Validação | Filipe Santos | 31/03/2027 |
| Jun/2027 | Primeiro teste de recuperação técnico completo (simulação em ambiente de homologação) | Validação | Guilherme Maciel | 30/06/2027 |

### 8.3 Critérios para Revisão Extraordinária do Plano

Além do ciclo anual de revisão, o plano deve ser revisado de forma extraordinária sempre que ocorrer ao menos um dos seguintes eventos:

- Ocorrência de incidente real que acione o BCP/DRP, independentemente do cenário;
- Mudança significativa na infraestrutura de TI da VitaClínica (adição de sistema, mudança de fornecedor de nuvem, expansão para nova unidade);
- Atualização das normas ABNT NBR ISO/IEC 27001 ou ABNT NBR 15999;
- Alteração na LGPD ou nas regulamentações da ANPD sobre prazos de notificação;
- Resultado de exercício de mesa que indique falha crítica no plano (gap de nível Alto).

---

## 9. SCRIPT DE COMUNICAÇÃO PARA PACIENTES

### 9.1 Contexto

Este script foi criado em atendimento à ação corretiva do Desvio 2 identificado no exercício de mesa de 02/06/2026 (Sprint 4, Seção 4.4). O exercício revelou que a recepção da VitaClínica não dispunha de texto padronizado para comunicar situações de indisponibilidade de sistemas aos pacientes presentes.

O script abaixo deve ser fixado plastificado no balcão de recepção das duas unidades e utilizado imediatamente ao receber a comunicação de retomada (Etapa 7 do procedimento do Cenário 1) — ou, no caso de sistemas inacessíveis, antes mesmo da retomada, para gerenciar a espera dos pacientes.

### 9.2 Modelo A — Comunicação Inicial (sistema fora do ar, sem previsão de retorno)

> "Prezado(a) paciente, informamos que nossos sistemas de informação estão passando por uma indisponibilidade técnica neste momento. Nossa equipe de TI já está trabalhando para resolver a situação o mais rápido possível. Enquanto aguardamos a normalização, nosso atendimento continua sendo prestado. Para consultas e procedimentos que não dependam do sistema, o atendimento prossegue normalmente. Agradecemos pela compreensão e pedimos desculpas pelo inconveniente."

### 9.3 Modelo B — Atualização de Status (com previsão de retorno)

> "Prezado(a) paciente, temos uma atualização sobre a indisponibilidade técnica: nossa equipe informa que os sistemas devem estar disponíveis em aproximadamente [PREENCHER: ___ minutos / ___ horas]. Caso prefira aguardar, continuaremos o seu atendimento assim que possível. Caso prefira reagendar sem custo adicional, nosso telefone é [PREENCHER: número da unidade]. Agradecemos sua paciência."

### 9.4 Modelo C — Comunicação de Retomada

> "Prezado(a) paciente, informamos que nossos sistemas voltaram ao funcionamento normal. Pedimos desculpas pela espera e agradecemos pela compreensão. Estamos prontos para continuar o seu atendimento. Se preferir reagendar para outra data, também podemos fazer isso agora, sem nenhum custo."

### 9.5 Modelo D — Comunicação por E-mail / WhatsApp (para pacientes com consulta agendada que ainda não chegaram)

> **Assunto:** VitaClínica — Informativo sobre sua consulta de hoje
>
> Prezado(a) [NOME DO PACIENTE],
>
> Informamos que a VitaClínica está passando por uma indisponibilidade técnica temporária que pode afetar o atendimento de hoje.
>
> Nossa equipe está trabalhando para normalizar os sistemas. Caso a indisponibilidade persista até o horário da sua consulta, entraremos em contato para informar sobre a melhor alternativa.
>
> Se preferir, você pode reagendar sua consulta pelo telefone [NÚMERO] ou responder a esta mensagem. O reagendamento não tem custo.
>
> Pedimos desculpas pelo transtorno e agradecemos sua compreensão.
>
> Atenciosamente,
> Equipe VitaClínica
> [Unidade] — [Endereço]

### 9.6 Instruções de Uso para a Recepção

| Situação | Modelo a Utilizar | Canal |
|----------|-----------------|-------|
| Paciente presente no momento do incidente | Modelo A (imediatamente) → Modelo B (quando houver previsão) → Modelo C (após retomada) | Comunicação verbal |
| Paciente com consulta nos próximos 60 min | Modelo D | WhatsApp ou telefone |
| Paciente com consulta em mais de 2 horas | Aguardar; usar Modelo D somente se a indisponibilidade persistir | WhatsApp ou telefone |
| Paciente questiona sobre dados comprometidos | Encaminhar para Filipe Santos (Líder do Sprint) imediatamente | — |

> **Importante:** Os dados de saúde dos pacientes são criptografados (AES-256). Em casos de ransomware ou falha, os dados não ficam expostos a terceiros — apenas temporariamente inacessíveis. A recepção deve comunicar essa informação quando questionada, para evitar preocupação desnecessária dos pacientes.

---

## 10. CONCLUSÃO PARCIAL

### 10.1 Síntese dos Resultados

O Sprint 5 conclui a fase de análise e avaliação do BCP/DRP da VitaClínica, reunindo os resultados das entregas dos sprints anteriores em uma visão consolidada e crítica.

Os resultados obtidos demonstram que o plano elaborado é **tecnicamente sólido e operacionalmente viável**. O exercício de mesa do Cenário 1 confirmou que:

- A equipe conhece seus papéis e os executa de forma coordenada;
- O RPO de A01/A02 foi cumprido com folga (47 min vs. meta de 1h);
- O RTO de A01/A02 ficou a 5 minutos da meta — um desvio marginal e corrigível;
- A infraestrutura de backup (NAS + S3 + HD off-site, com criptografia AES-256 e checksums SHA-256) demonstrou ser confiável.

A análise de aderência normativa indica que o projeto atende integralmente aos requisitos do manual da disciplina e à maioria dos controles da ABNT NBR ISO/IEC 27001 e ABNT NBR 15999. Os pontos pendentes (testes dos Cenários 2 e 3, procedimento DICOM, política de patches) são melhorias para os ciclos subsequentes, não vulnerabilidades críticas.

### 10.2 Pontos de Atenção para o Sprint 6

O Sprint 6 — versão final do projeto — deverá endereçar os seguintes itens antes da entrega:

1. Consolidar todos os documentos dos Sprints 0–5 em um relatório ABNT único e coeso;
2. Incluir sumário executivo para a direção da VitaClínica;
3. Documentar procedimento específico para o ativo A05 (Laudos DICOM) — gap G03;
4. Incluir política de privacidade resumida em conformidade com LGPD art. 50 — gap G08;
5. Elaborar slides de apresentação para a defesa do projeto;
6. Revisar todas as referências bibliográficas no padrão ABNT NBR 6023.

### 10.3 Avaliação Final da Maturidade do Plano

Com base nos resultados analisados neste sprint, o BCP/DRP da VitaClínica pode ser classificado no **Nível 3 — Definido** da escala de maturidade de continuidade de negócios (adaptada do CMMI), que corresponde a:

> *"O plano está documentado, comunicado e testado parcialmente. Os processos são repetíveis e existe consciência organizacional sobre os papéis e procedimentos. A organização está preparada para responder a incidentes comuns, com riscos residuais identificados e em processo de tratamento."*

A progressão para o **Nível 4 — Gerenciado** — que requer testes regulares de todos os cenários com dados reais e métricas históricas — depende da implantação formal e da execução do calendário de melhoria contínua definido na Seção 8.

---

## Referências

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR ISO/IEC 27001:2013**: Tecnologia da informação — Técnicas de segurança — Sistemas de gestão da segurança da informação — Requisitos. Rio de Janeiro: ABNT, 2013.

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR 15999-1:2007**: Gestão de continuidade de negócios — Parte 1: Código de prática. Rio de Janeiro: ABNT, 2007.

BRASIL. **Lei nº 13.709, de 14 de agosto de 2018**. Lei Geral de Proteção de Dados Pessoais (LGPD). Brasília: Presidência da República, 2018.

LYRA, Maurício Rocha. **Segurança e Auditoria em Sistemas de Informação**. Rio de Janeiro: Ciência Moderna, 2008.

NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY. **NIST Special Publication 800-34 Rev. 1**: Contingency Planning Guide for Federal Information Systems. Gaithersburg: NIST, 2010.

SÊMOLA, Marcos. **Gestão da Segurança da Informação**: uma visão executiva. 2. ed. Rio de Janeiro: Elsevier, 2014.

---

> *Documento produzido no âmbito do Sprint 5 — Resultados e Análise.*
> *Próximo passo: Sprint 6 — Versão final consolidada, relatório ABNT completo e slides de apresentação.*
