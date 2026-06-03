# Sprint 1 — Introdução, Objetivos, Escopo e Análise de Riscos

> Projeto Integrado II — Tecnologia em Análise e Desenvolvimento de Sistemas (TADS)
> Semestre 1/2026 | Professor Roberto Maia
> Empresa fictícia: VitaClínica

---

## 1. INTRODUÇÃO

A crescente dependência de sistemas de informação nas organizações de saúde transformou os dados digitais em um dos ativos mais críticos para a continuidade operacional. Clínicas médicas, hospitais e laboratórios dependem de sistemas eletrônicos para registrar prontuários, realizar agendamentos, processar resultados de exames e gerenciar informações financeiras. Nesse contexto, a indisponibilidade desses sistemas, mesmo que por períodos curtos, pode comprometer diretamente a qualidade do atendimento ao paciente e expor a organização a riscos legais, financeiros e reputacionais significativos.

No Brasil, a promulgação da Lei Geral de Proteção de Dados Pessoais — LGPD (Lei nº 13.709/2018) — impôs novas obrigações às organizações que tratam dados pessoais, incluindo dados de saúde, classificados como dados sensíveis pelo artigo 5º, inciso II. O descumprimento das exigências da LGPD pode resultar em sanções administrativas que variam de advertências a multas de até 2% do faturamento da empresa, limitadas a R$ 50 milhões por infração, além de danos irreparáveis à imagem institucional.

Diante desse cenário, a elaboração de um Plano de Backup e de um Plano de Continuidade de Negócios e Recuperação de Desastres (BCP/DRP — *Business Continuity Plan / Disaster Recovery Plan*) deixou de ser uma boa prática opcional e passou a ser uma necessidade estratégica para qualquer organização que gerencie dados sensíveis. Referências internacionais consolidadas, como a norma ABNT NBR ISO/IEC 27001:2013, que trata de sistemas de gestão de segurança da informação, e o NIST Special Publication 800-34, que fornece diretrizes para planejamento de contingência em sistemas de informação, orientam as organizações sobre como estruturar esses planos de forma eficaz e sustentável.

A **VitaClínica** é uma clínica médica de médio porte com duas unidades no interior do estado de São Paulo — a Unidade Central e a Unidade Bairro — que atende em média 200 pacientes por dia entre as duas localidades. Sua infraestrutura de TI é composta por servidores locais em cada unidade, estações de trabalho, um Sistema de Prontuário Eletrônico do Paciente (PEP), sistema de agendamento online, sistema financeiro e uma rede privada virtual (VPN) interligando as duas unidades.

Apesar do volume e da sensibilidade dos dados tratados diariamente, a VitaClínica **não possui qualquer plano formalizado de backup ou recuperação de desastres**. Os dados dos pacientes são armazenados em servidores locais sem política de cópia de segurança definida, sem procedimentos de resposta a incidentes documentados e sem definição de responsabilidades em caso de falhas críticas. Essa ausência representa um risco concreto e imediato para a organização: uma falha de hardware, um ataque de ransomware ou um desastre físico como um incêndio poderia resultar em perda permanente de dados de pacientes, interrupção prolongada dos atendimentos e violações da LGPD.

O presente projeto propõe, portanto, a elaboração de um Plano de Backup estruturado — seguindo a regra 3-2-1 — e de um Plano de Continuidade de Negócios e Recuperação de Desastres para a VitaClínica, com o objetivo de mitigar os riscos identificados, garantir a proteção dos dados sensíveis sob sua responsabilidade e assegurar a continuidade dos serviços essenciais de saúde prestados à comunidade.

---

## 2. OBJETIVOS

### 2.1 Objetivo Geral

Elaborar um Plano de Backup e um Plano de Continuidade de Negócios e Recuperação de Desastres (BCP/DRP) para a VitaClínica, assegurando a proteção dos dados sensíveis de pacientes, a continuidade dos serviços de saúde e a conformidade com a Lei Geral de Proteção de Dados Pessoais (LGPD — Lei nº 13.709/2018), diante de incidentes que possam comprometer a disponibilidade, integridade ou confidencialidade da infraestrutura de tecnologia da informação da organização.

### 2.2 Objetivos Específicos

1. Identificar e classificar os ativos de informação críticos da VitaClínica, determinando o nível de criticidade de cada ativo em relação à continuidade operacional e à conformidade com a LGPD.

2. Realizar uma análise de riscos abrangendo as principais ameaças ao ambiente de TI da organização, com foco nos três cenários prioritários: falha de hardware, ataque cibernético (ransomware) e desastre físico (incêndio).

3. Definir estratégias de backup em conformidade com a regra 3-2-1 — três cópias dos dados, em dois tipos de mídia diferentes, com uma cópia armazenada em local off-site —, observando as boas práticas preconizadas pela ABNT NBR ISO/IEC 27001:2013.

4. Estabelecer métricas de *Recovery Point Objective* (RPO) e *Recovery Time Objective* (RTO) adequadas ao ambiente de saúde, considerando a criticidade de cada ativo e o impacto operacional de sua indisponibilidade.

5. Descrever procedimentos detalhados de resposta e recuperação para os três cenários de desastre identificados, incluindo responsabilidades, fluxo de ações e critérios de acionamento do plano.

6. Consolidar todos os planos, procedimentos e evidências em um relatório técnico completo no formato ABNT, em conformidade com as normas de apresentação de trabalhos acadêmicos.

---

## 3. ESCOPO

### 3.1 Abrangência do Projeto

O presente projeto abrange as duas unidades da VitaClínica — Unidade Central e Unidade Bairro — e contempla os seguintes elementos:

**Infraestrutura de TI coberta:**
- Servidores locais de cada unidade (servidor de aplicações e servidor de banco de dados)
- Estações de trabalho utilizadas por médicos, recepcionistas e equipe administrativa
- Equipamentos de rede (switches, roteadores, equipamentos VPN)
- Sistemas de software em uso: PEP, sistema de agendamento, sistema financeiro e comunicação interna

**Ativos de informação cobertos:**
- Prontuários eletrônicos dos pacientes
- Dados de agendamento de consultas e exames
- Laudos laboratoriais e imagens médicas
- Dados financeiros e de faturamento
- Dados cadastrais de pacientes (dados pessoais e dados sensíveis nos termos da LGPD)

**Cenários de desastre cobertos:**
- Falha de hardware (servidor físico)
- Ataque cibernético do tipo ransomware
- Desastre físico (incêndio em uma das unidades)

**Documentação a ser produzida:**
- Política de Backup (regra 3-2-1, frequência, retenção, responsabilidades)
- Plano de Continuidade de Negócios (BCP)
- Plano de Recuperação de Desastres (DRP)
- Definição de RPO e RTO por ativo
- Procedimentos de resposta a incidentes

### 3.2 Limites do Projeto

O presente projeto **não abrange** os seguintes elementos:

- Desenvolvimento ou modificação de sistemas de software
- Implementação real de infraestrutura de TI (aquisição de equipamentos, contratação de serviços em nuvem ou qualquer despesa real)
- Realização de testes de restauração em ambiente de produção real
- Definição de políticas de segurança da informação além daquelas diretamente relacionadas ao backup e à continuidade
- Elaboração de análise de impacto nos negócios (BIA — *Business Impact Analysis*) em sua forma completa, sendo abordados apenas os elementos essenciais para a definição de RPO e RTO

### 3.3 Restrições e Premissas

Para a elaboração deste projeto, adotam-se as seguintes premissas:

- A VitaClínica é uma organização fictícia criada exclusivamente para fins acadêmicos
- Todos os dados, sistemas e infraestrutura descritos são conceituais
- As soluções tecnológicas indicadas são referenciadas como exemplos de mercado e não implicam recomendação comercial
- O projeto segue os requisitos da disciplina de Projeto Integrado II do curso de TADS — Anhanguera, semestre 1/2026

---

## 4. ANÁLISE DE RISCOS

A análise de riscos é uma etapa fundamental no desenvolvimento de qualquer plano de continuidade de negócios. Conforme o NIST SP 800-34, a identificação e avaliação dos riscos permite que a organização compreenda as ameaças a que está sujeita e priorize os esforços de proteção e recuperação de acordo com o potencial de impacto em suas operações. Esta seção apresenta o inventário dos ativos críticos da VitaClínica, as principais ameaças identificadas e a matriz de riscos resultante.

### 4.1 Identificação dos Ativos Críticos

A tabela a seguir apresenta os principais ativos de informação da VitaClínica, classificados por criticidade para a continuidade operacional e para a conformidade com a LGPD.

| ID   | Ativo                                     | Descrição                                                                 | Unidade        | Criticidade |
|------|-------------------------------------------|---------------------------------------------------------------------------|----------------|-------------|
| A01  | Servidor de Prontuários Eletrônicos (PEP) | Servidor que hospeda o sistema de prontuário eletrônico dos pacientes     | Ambas          | Crítica      |
| A02  | Banco de Dados de Pacientes               | Base de dados com informações pessoais e histórico clínico dos pacientes  | Ambas          | Crítica      |
| A03  | Sistema de Agendamento Online             | Sistema responsável pelo agendamento de consultas e exames                | Ambas          | Alta         |
| A04  | Sistema Financeiro                        | Sistema de gestão financeira, faturamento e contas a pagar/receber        | Unidade Central| Alta         |
| A05  | Laudos e Imagens Médicas                  | Arquivos de laudos laboratoriais e imagens de exames (DICOM e PDF)        | Ambas          | Crítica      |
| A06  | Link VPN entre Unidades                   | Conexão de rede privada virtual interligando Unidade Central e Unidade Bairro | Ambas      | Alta         |
| A07  | Estações de Trabalho                      | Computadores utilizados por médicos, recepcionistas e administrativos     | Ambas          | Média        |
| A08  | Sistema de E-mail Interno                 | Comunicação eletrônica entre colaboradores e entre unidades               | Ambas          | Média        |

**Legenda de criticidade:**
- **Crítica:** A indisponibilidade do ativo impede diretamente a prestação de serviços de saúde ou gera violação da LGPD
- **Alta:** A indisponibilidade causa impacto operacional significativo, mas não impede imediatamente o atendimento
- **Média:** A indisponibilidade gera inconveniência operacional sem comprometer os atendimentos essenciais

### 4.2 Identificação de Ameaças e Vulnerabilidades

Com base no levantamento da infraestrutura e nos cenários de desastre previstos no escopo do projeto, foram identificadas as seguintes ameaças e suas respectivas vulnerabilidades associadas:

| ID   | Ameaça                          | Ativos Afetados              | Vulnerabilidade Associada                                              |
|------|---------------------------------|------------------------------|------------------------------------------------------------------------|
| AM01 | Falha de hardware (servidor)    | A01, A02, A05                | Ausência de redundância de hardware e de cópias de segurança regulares |
| AM02 | Ataque de ransomware            | A01, A02, A03, A04, A05      | Ausência de política de segurança, backups off-site e segmentação de rede |
| AM03 | Incêndio / desastre físico      | Todos os ativos              | Ausência de cópias off-site e de plano de continuidade formalizado     |
| AM04 | Falha de energia elétrica       | A01, A02, A03, A06           | Ausência de nobreak (UPS) e gerador de emergência                      |
| AM05 | Falha de conectividade (VPN)    | A06, A03                     | Dependência de link único sem redundância de rede                      |
| AM06 | Erro humano                     | A01, A02, A04                | Ausência de políticas de acesso, controle de versão e treinamento      |
| AM07 | Acesso não autorizado           | A01, A02, A04, A05           | Controles de acesso e autenticação insuficientes                       |

### 4.3 Matriz de Riscos

A matriz de riscos foi construída com base na avaliação de dois parâmetros para cada ameaça identificada: a **probabilidade de ocorrência** e o **impacto** sobre as operações da VitaClínica. Cada parâmetro foi graduado em três níveis — Baixo (1), Médio (2) e Alto (3) —, e o **nível de risco** foi calculado pelo produto desses dois valores, conforme metodologia amplamente adotada em análises de risco de segurança da informação (SÊMOLA, 2014).

**Classificação do nível de risco:**
- **Crítico (7–9):** Exige ação imediata — prioridade máxima no plano de continuidade
- **Alto (4–6):** Exige plano de mitigação e procedimentos de resposta documentados
- **Médio (2–3):** Monitoramento contínuo e controles preventivos recomendados
- **Baixo (1):** Risco aceitável com os controles básicos existentes

| ID   | Ameaça                       | Probabilidade       | Impacto        | Nível de Risco     | Prioridade |
|------|------------------------------|---------------------|----------------|--------------------|------------|
| AM01 | Falha de hardware            | Alta (3)            | Alto (3)       | **9 — Crítico**    | P1         |
| AM02 | Ransomware                   | Alta (3)            | Alto (3)       | **9 — Crítico**    | P1         |
| AM03 | Incêndio / desastre físico   | Baixa (1)           | Alto (3)       | **3 — Médio**      | P3         |
| AM04 | Falha de energia             | Média (2)           | Alto (3)       | **6 — Alto**       | P2         |
| AM05 | Falha de conectividade (VPN) | Média (2)           | Médio (2)      | **4 — Alto**       | P2         |
| AM06 | Erro humano                  | Alta (3)            | Médio (2)      | **6 — Alto**       | P2         |
| AM07 | Acesso não autorizado        | Média (2)           | Alto (3)       | **6 — Alto**       | P2         |

### 4.4 Síntese da Análise de Riscos

A análise demonstra que os riscos de maior criticidade para a VitaClínica são a **falha de hardware** e o **ataque de ransomware**, ambos com nível de risco 9 (Crítico). Esses cenários combinam alta probabilidade de ocorrência com impacto operacional severo, potencialmente resultando em perda irreversível de dados de pacientes e interrupção prolongada dos atendimentos.

O **incêndio**, embora de baixa probabilidade, apresenta o maior potencial destrutivo de todos os cenários mapeados, podendo comprometer simultaneamente todos os ativos físicos de uma unidade, motivo pelo qual também integra o escopo obrigatório do BCP/DRP. Os demais riscos classificados como "Alto" demandam planos de mitigação e procedimentos de resposta documentados, que serão desenvolvidos nas próximas etapas do projeto.

Os três cenários prioritários — **falha de hardware (AM01)**, **ransomware (AM02)** e **incêndio (AM03)** — fundamentarão os procedimentos de recuperação a serem detalhados no Sprint 3, quando serão definidos os RTO, RPO e os fluxos de resposta a cada tipo de incidente.

---

## Referências (parciais — serão consolidadas no relatório final)

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR ISO/IEC 27001:2013**: Tecnologia da informação — Técnicas de segurança — Sistemas de gestão da segurança da informação — Requisitos. Rio de Janeiro: ABNT, 2013.

BRASIL. **Lei nº 13.709, de 14 de agosto de 2018**. Lei Geral de Proteção de Dados Pessoais (LGPD). Brasília: Presidência da República, 2018. Disponível em: https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm. Acesso em: jun. 2026.

NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY. **NIST Special Publication 800-34 Rev. 1**: Contingency Planning Guide for Federal Information Systems. Gaithersburg: NIST, 2010.

SÊMOLA, Marcos. **Gestão da Segurança da Informação**: uma visão executiva. 2. ed. Rio de Janeiro: Elsevier, 2014.

---

> *Documento produzido no âmbito do Sprint 1 — sujeito a revisão e complementação nas etapas subsequentes.*
