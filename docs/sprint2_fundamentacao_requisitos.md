# Sprint 2 — Fundamentação Teórica e Requisitos

> Projeto Integrado II — Tecnologia em Análise e Desenvolvimento de Sistemas (TADS)
> Semestre 1/2026 | Professor Roberto Maia
> Empresa fictícia: VitaClínica

---

## 1. FUNDAMENTAÇÃO TEÓRICA

Esta seção apresenta os conceitos técnicos e normativos que fundamentam o desenvolvimento do Plano de Backup e do Plano de Continuidade de Negócios e Recuperação de Desastres (BCP/DRP) da VitaClínica. Os conceitos aqui expostos embasam as decisões metodológicas adotadas ao longo do projeto e estabelecem o referencial teórico para a análise e o planejamento realizados nas seções subsequentes.

### 1.1 Continuidade de Negócios e Recuperação de Desastres

A gestão da continuidade de negócios é definida pela ABNT NBR 15999 como um processo holístico de gestão que identifica as ameaças potenciais a uma organização e os impactos que tais ameaças, se concretizadas, podem causar às operações do negócio. Seu objetivo principal é fornecer uma estrutura que permita à organização manter sua capacidade de operar em um nível aceitável predefinido, mesmo diante de situações adversas.

No contexto da tecnologia da informação, esse processo se desdobra em dois planos complementares:

O **Plano de Continuidade de Negócios (BCP — *Business Continuity Plan*)** é o conjunto documentado de procedimentos e informações desenvolvido, compilado e mantido em estado de prontidão para uso em incidentes. Seu escopo é amplo, abrangendo as pessoas, os processos, os sistemas e a infraestrutura necessários para manter as atividades críticas da organização em funcionamento durante e após um evento disruptivo. Conforme o NIST SP 800-34 (2010), o BCP representa a estratégia global de preparação da organização para enfrentar interrupções de qualquer natureza.

O **Plano de Recuperação de Desastres (DRP — *Disaster Recovery Plan*)** é um subconjunto do BCP com foco específico na recuperação dos sistemas de tecnologia da informação e comunicação após um desastre. Enquanto o BCP se preocupa com a continuidade das operações de negócio de forma ampla, o DRP detalha os procedimentos técnicos para restaurar a infraestrutura de TI a um estado operacional dentro dos prazos estabelecidos. Sêmola (2014) descreve o DRP como o conjunto de estratégias e ações que visam retomar as atividades de TI no menor tempo possível após um incidente grave.

A ausência de ambos os planos na VitaClínica representa uma lacuna crítica de governança em segurança da informação, especialmente considerando o volume e a sensibilidade dos dados de saúde gerenciados diariamente pela organização.

### 1.2 Recovery Point Objective (RPO) e Recovery Time Objective (RTO)

Duas métricas fundamentais orientam o planejamento de qualquer estratégia de continuidade e recuperação: o RPO e o RTO. Sua correta definição é essencial para dimensionar as soluções de backup e os procedimentos de recuperação de forma proporcional ao impacto real de cada ativo para o negócio.

O **Recovery Point Objective (RPO)**, ou Objetivo de Ponto de Recuperação, define o período máximo de dados que a organização aceita perder em caso de incidente. Em termos práticos, o RPO determina a frequência mínima com que os backups devem ser realizados. Se o RPO de um sistema é de duas horas, por exemplo, os backups devem ocorrer pelo menos a cada duas horas, de modo a garantir que, em caso de falha, no máximo duas horas de dados sejam perdidas. Quanto menor o RPO, maior o custo e a complexidade da solução de backup requerida (NIST SP 800-34, 2010).

O **Recovery Time Objective (RTO)**, ou Objetivo de Tempo de Recuperação, define o tempo máximo tolerável para a restauração de um sistema ou serviço após uma interrupção. O RTO estabelece o prazo dentro do qual os sistemas devem ser restabelecidos para que os impactos ao negócio permaneçam dentro de limites aceitáveis. Para uma clínica médica como a VitaClínica, um RTO elevado para o sistema de prontuário eletrônico significaria que médicos ficam sem acesso ao histórico dos pacientes por horas, o que pode comprometer diretamente a qualidade e a segurança do atendimento.

A relação entre RPO e RTO orienta diretamente as escolhas tecnológicas do plano de backup: sistemas com RPO e RTO baixos requerem soluções de alta disponibilidade, como replicação em tempo real e backups contínuos, enquanto sistemas com tolerâncias mais elevadas podem ser atendidos por backups periódicos convencionais.

### 1.3 Regra 3-2-1 de Backup

A regra 3-2-1 é uma das diretrizes mais consolidadas em gestão de backup e é amplamente referenciada como boa prática em segurança da informação, incluindo nas orientações da ABNT NBR ISO/IEC 27001:2013. Seu princípio é simples e eficaz:

- **3** cópias dos dados devem existir (o dado original mais duas cópias de backup)
- **2** tipos diferentes de mídia de armazenamento devem ser utilizados (por exemplo, disco rígido e fita magnética, ou disco local e armazenamento em nuvem)
- **1** cópia deve estar armazenada em local off-site, isto é, geograficamente separado das instalações principais da organização

A razão pela qual essa regra é tão eficaz reside na diversificação do risco. Manter apenas uma cópia local protege contra falhas de hardware pontuais, mas não contra desastres físicos como incêndio ou alagamento, que podem destruir simultaneamente o original e o backup local. A cópia off-site garante a sobrevivência dos dados mesmo em cenários de destruição total de uma das unidades. O uso de duas mídias distintas, por sua vez, mitiga o risco de falhas inerentes a um tipo específico de suporte (como a degradação de fitas magnéticas ou a obsolescência de determinados formatos).

Para a VitaClínica, a implementação da regra 3-2-1 será estruturada da seguinte forma conceitual: cópias locais em NAS (*Network Attached Storage*) em cada unidade, cópia em nuvem (Amazon S3 ou equivalente) e cópia off-site em HD externo criptografado com rotação periódica.

### 1.4 LGPD e o Setor de Saúde

A Lei Geral de Proteção de Dados Pessoais — LGPD (Lei nº 13.709/2018) — estabelece regras sobre coleta, armazenamento, tratamento e compartilhamento de dados pessoais no Brasil. Para organizações de saúde como a VitaClínica, a LGPD possui implicações especialmente relevantes, pois os dados de saúde são classificados como **dados sensíveis** pelo artigo 5º, inciso II da lei.

O artigo 11 da LGPD impõe condições mais restritivas para o tratamento de dados sensíveis em comparação aos dados pessoais comuns. O tratamento de dados de saúde somente é permitido sem consentimento do titular em situações específicas, como para a tutela da saúde do próprio titular, e deve sempre ser realizado por profissionais de saúde ou por entidades sanitárias. Em todos os casos, o controlador dos dados — no caso da VitaClínica, a própria clínica — é responsável por adotar medidas técnicas e administrativas aptas a proteger esses dados de acessos não autorizados e de situações acidentais ou ilícitas de destruição, perda, alteração ou vazamento.

A ausência de um plano de backup e de continuidade coloca a VitaClínica em situação de não conformidade com os princípios da LGPD, em especial com o princípio da **segurança** (art. 6º, VII) e o princípio da **prevenção** (art. 6º, VIII). Em caso de incidente de segurança com dados pessoais, a organização tem a obrigação de comunicar à Autoridade Nacional de Proteção de Dados (ANPD) e ao titular, podendo estar sujeita às sanções previstas no artigo 52, que incluem multas de até 2% do faturamento, limitadas a R$ 50 milhões por infração.

A elaboração do BCP/DRP para a VitaClínica, portanto, além de ser uma boa prática de gestão, é uma exigência implícita da LGPD para organizações que tratam dados sensíveis de saúde.

### 1.5 Tríade CIA: Confidencialidade, Integridade e Disponibilidade

A segurança da informação é fundamentada em três pilares essenciais, conhecidos como a tríade CIA (*Confidentiality, Integrity, Availability*), conforme preconizado pela ABNT NBR ISO/IEC 27001:2013. Compreender esses conceitos é indispensável para o desenvolvimento de qualquer plano de proteção de dados.

A **Confidencialidade** refere-se à garantia de que a informação é acessível apenas por pessoas, entidades ou processos autorizados. No contexto da VitaClínica, a confidencialidade diz respeito à proteção dos dados de saúde dos pacientes contra acessos indevidos, sejam eles internos (funcionários sem autorização) ou externos (ataques cibernéticos). A LGPD reforça essa exigência ao classificar os dados de saúde como sensíveis.

A **Integridade** é a propriedade que garante que a informação não foi alterada de forma não autorizada ou inesperada. Em um ambiente de saúde, a violação da integridade pode ter consequências graves: um prontuário eletrônico alterado incorretamente pode levar a diagnósticos errados ou à administração incorreta de medicamentos. O backup é um dos principais mecanismos de garantia de integridade, pois permite restaurar uma versão anterior e íntegra dos dados em caso de corrupção ou alteração indevida.

A **Disponibilidade** é a garantia de que os sistemas e as informações estejam acessíveis e operacionais sempre que necessários pelos usuários autorizados. Este pilar é o mais diretamente relacionado ao BCP/DRP: o objetivo central dos planos de continuidade é assegurar que os sistemas críticos da VitaClínica estejam disponíveis dentro dos prazos estabelecidos pelos RTO de cada ativo, mesmo após eventos disruptivos. Lyra (2008) destaca que a disponibilidade é frequentemente o requisito de segurança mais crítico em ambientes operacionais de missão crítica, como é o caso dos sistemas de saúde.

---

## 2. REQUISITOS DO PROJETO

Com base na fundamentação teórica apresentada e na análise de riscos realizada no Sprint 1, esta seção define os requisitos que o Plano de Backup e o BCP/DRP da VitaClínica devem atender. Os requisitos estão organizados em duas categorias: **requisitos funcionais**, que descrevem o que o plano deve ser capaz de fazer, e **requisitos não funcionais**, que estabelecem as restrições, qualidades e padrões que o plano deve observar.

### 2.1 Requisitos Funcionais

Os requisitos funcionais definem as capacidades e os comportamentos esperados do plano de backup e do BCP/DRP.

| ID   | Requisito Funcional                                                                                                      | Prioridade |
|------|--------------------------------------------------------------------------------------------------------------------------|------------|
| RF01 | O plano de backup deve prever cópias automatizadas diárias de todos os ativos classificados como Críticos (A01, A02, A05) | Alta       |
| RF02 | O plano de backup deve seguir a regra 3-2-1: três cópias, duas mídias distintas, uma cópia off-site                      | Alta       |
| RF03 | O BCP/DRP deve cobrir no mínimo três cenários de desastre: falha de hardware, ransomware e incêndio                      | Alta       |
| RF04 | O DRP deve definir procedimentos específicos de recuperação para cada cenário de desastre coberto                         | Alta       |
| RF05 | O plano deve definir RPO e RTO individuais para cada ativo classificado como Crítico ou Alto                              | Alta       |
| RF06 | O plano deve definir uma matriz de responsabilidades com os papéis e as ações de cada membro da equipe em caso de incidente | Alta     |
| RF07 | O plano deve prever testes periódicos de restauração de backup, com frequência mínima trimestral                          | Média      |
| RF08 | O plano deve incluir procedimentos de comunicação de incidentes, contemplando notificações internas e à ANPD conforme a LGPD | Alta    |
| RF09 | O plano deve prever um processo de ativação formal do BCP, com critérios claros de quando acionar o plano                 | Média      |
| RF10 | O plano deve incluir um processo de revisão e atualização anual, ou sempre que ocorrer mudança significativa na infraestrutura | Baixa  |

### 2.2 Requisitos Não Funcionais

Os requisitos não funcionais definem as restrições de qualidade, segurança e conformidade que o plano deve observar.

| ID    | Requisito Não Funcional                                                                                                              | Prioridade |
|-------|--------------------------------------------------------------------------------------------------------------------------------------|------------|
| RNF01 | Todos os backups devem ser criptografados com algoritmo AES-256 ou equivalente, tanto em trânsito quanto em repouso                  | Alta       |
| RNF02 | O período mínimo de retenção dos backups deve ser de 90 dias para ativos críticos e 30 dias para ativos de prioridade média           | Alta       |
| RNF03 | A cópia off-site deve estar armazenada em local geograficamente distante de ambas as unidades (mínimo 30 km)                         | Alta       |
| RNF04 | Soluções de backup em nuvem devem utilizar provedores que garantam o armazenamento de dados em território brasileiro ou em país com proteção de dados adequada, conforme a LGPD | Alta |
| RNF05 | O RTO máximo para ativos classificados como Críticos não deve ultrapassar 4 horas                                                    | Alta       |
| RNF06 | O RPO máximo para ativos classificados como Críticos não deve ultrapassar 1 hora                                                     | Alta       |
| RNF07 | Os procedimentos do plano devem ser escritos em linguagem clara e objetiva, de modo a serem executados por qualquer membro capacitado da equipe, mesmo sob pressão | Média |
| RNF08 | O plano deve ser armazenado em mídia impressa e em formato digital em pelo menos dois locais distintos, garantindo sua disponibilidade mesmo durante um incidente de TI | Média |
| RNF09 | Os backups devem ser monitorados de forma automatizada, com geração de alertas em caso de falha na execução                          | Média      |
| RNF10 | O plano deve estar em conformidade com a ABNT NBR ISO/IEC 27001:2013 e com o NIST SP 800-34 Rev. 1                                   | Alta       |

### 2.3 Definição de RPO e RTO por Ativo Crítico

A tabela a seguir consolida as métricas de RPO e RTO definidas para cada ativo de informação classificado como Crítico ou Alto no inventário realizado no Sprint 1. Esses valores foram estabelecidos com base na criticidade de cada ativo para a continuidade das operações da VitaClínica e no impacto direto de sua indisponibilidade sobre o atendimento aos pacientes e a conformidade com a LGPD.

| ID   | Ativo                                | Criticidade | RPO       | RTO       | Justificativa                                                                                       |
|------|--------------------------------------|-------------|-----------|-----------|-----------------------------------------------------------------------------------------------------|
| A01  | Servidor de Prontuários (PEP)        | Crítica     | 1 hora    | 2 horas   | Prontuários são indispensáveis para o atendimento seguro; perda superior a 1h é inaceitável         |
| A02  | Banco de Dados de Pacientes          | Crítica     | 1 hora    | 2 horas   | Dados sensíveis sob LGPD; integridade e disponibilidade são requisitos legais                       |
| A05  | Laudos e Imagens Médicas             | Crítica     | 4 horas   | 4 horas   | Laudos históricos podem ser consultados a posteriori; impacto imediato é menor que PEP              |
| A03  | Sistema de Agendamento Online        | Alta        | 4 horas   | 4 horas   | Impacto operacional alto, mas atendimentos em curso não são comprometidos imediatamente             |
| A04  | Sistema Financeiro                   | Alta        | 8 horas   | 8 horas   | Impacto financeiro relevante, mas não compromete diretamente a segurança do paciente                |
| A06  | Link VPN entre Unidades              | Alta        | N/A       | 2 horas   | A VPN não armazena dados; RTO reflete o tempo máximo tolerável de isolamento entre as unidades      |

**Observação sobre A06:** O link VPN não possui RPO, pois não é um ativo de armazenamento de dados. O RTO estabelecido de 2 horas reflete o prazo máximo aceitável de isolamento entre a Unidade Central e a Unidade Bairro, após o qual as operações integradas entre as unidades ficam comprometidas.

---

## Referências (parciais — serão consolidadas no relatório final)

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR ISO/IEC 27001:2013**: Tecnologia da informação — Técnicas de segurança — Sistemas de gestão da segurança da informação — Requisitos. Rio de Janeiro: ABNT, 2013.

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR 15999-1:2007**: Gestão de continuidade de negócios — Parte 1: Código de prática. Rio de Janeiro: ABNT, 2007.

BRASIL. **Lei nº 13.709, de 14 de agosto de 2018**. Lei Geral de Proteção de Dados Pessoais (LGPD). Brasília: Presidência da República, 2018. Disponível em: https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm. Acesso em: jun. 2026.

LYRA, Maurício Rocha. **Segurança e Auditoria em Sistemas de Informação**. Rio de Janeiro: Ciência Moderna, 2008.

NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY. **NIST Special Publication 800-34 Rev. 1**: Contingency Planning Guide for Federal Information Systems. Gaithersburg: NIST, 2010.

SÊMOLA, Marcos. **Gestão da Segurança da Informação**: uma visão executiva. 2. ed. Rio de Janeiro: Elsevier, 2014.

---

> *Documento produzido no âmbito do Sprint 2 — sujeito a revisão e complementação nas etapas subsequentes.*
