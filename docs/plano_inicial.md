# Plano Inicial do Projeto — VitaClínica BCP/DRP

> Documento de planejamento preliminar — Sprint 0
> Projeto Integrado II — TADS | Semestre 1/2026

---

## 1. Apresentação da Empresa Fictícia

A **VitaClínica** é uma clínica médica de médio porte com duas unidades localizadas no interior do estado de São Paulo — uma unidade sede (Unidade Central) e uma unidade filial (Unidade Bairro). A clínica oferece serviços de clínica geral, pediatria, ginecologia e exames laboratoriais, atendendo em média 200 pacientes por dia entre as duas unidades.

A infraestrutura de TI da VitaClínica é composta por servidores locais em cada unidade, estações de trabalho, um sistema de prontuário eletrônico (PEP), sistema de agendamento online, sistema financeiro e uma rede interna interligando as duas unidades via VPN.

---

## 2. Problema Identificado

A VitaClínica **não possui atualmente nenhum plano formalizado de backup ou recuperação de desastres**. Os dados dos pacientes — incluindo prontuários, laudos e informações pessoais sensíveis — são armazenados em servidores locais sem política de cópia de segurança definida. Situações como falha de hardware, ataques cibernéticos ou desastres físicos podem resultar em perda irreversível de dados, interrupção dos atendimentos e violações da LGPD (Lei nº 13.709/2018).

---

## 3. Escopo Preliminar

### O que este projeto inclui:
- Levantamento e classificação dos ativos de informação críticos da VitaClínica
- Elaboração de uma Política de Backup (o que, quando, onde e como fazer backup)
- Definição de métricas de recuperação: RPO (Recovery Point Objective) e RTO (Recovery Time Objective)
- Elaboração do Plano de Continuidade de Negócios e Recuperação de Desastres (BCP/DRP)
- Cobertura de no mínimo 3 cenários de desastre: falha de hardware, ataque cibernético (ransomware) e desastre físico (incêndio)
- Relatório técnico completo no formato ABNT

### O que este projeto NÃO inclui:
- Desenvolvimento de sistemas ou aplicativos
- Implementação real de infraestrutura de TI
- Aquisição ou contratação de serviços reais de backup

---

## 4. Objetivos Preliminares

**Objetivo Geral:**
Elaborar um Plano de Backup e um Plano de Continuidade de Negócios/Recuperação de Desastres (BCP/DRP) para a VitaClínica, garantindo a proteção dos dados e a continuidade operacional diante de incidentes.

**Objetivos Específicos (preliminares):**
1. Identificar e classificar os ativos de informação críticos da VitaClínica
2. Definir estratégias de backup seguindo a regra 3-2-1 e boas práticas de segurança da informação
3. Estabelecer métricas de RPO e RTO adequadas ao ambiente de saúde
4. Descrever procedimentos claros de resposta e recuperação para os cenários de desastre identificados

---

## 5. Tecnologias Consideradas

| Camada | Tecnologia / Solução |
|--------|----------------------|
| Backup local | NAS (Network Attached Storage) em cada unidade |
| Backup em nuvem | Amazon S3 ou Google Cloud Storage (conceitual) |
| Backup off-site | HD externo criptografado com rotação semanal |
| Solução de backup | Veeam Backup (conceitual) |
| Monitoramento | Zabbix (conceitual) |
| VPN entre unidades | OpenVPN |

---

## 6. Cronograma Preliminar de Sprints

| Sprint | Foco | Prazo |
|--------|------|-------|
| Sprint 0 | Setup e organização inicial | Semana 1-2 |
| Sprint 1 | Problema, objetivos e escopo | Semana 3-4 |
| Sprint 2 | Fundamentação teórica e requisitos | Semana 5-6 |
| Sprint 3 | Projeto técnico e diagramas | Semana 7-8 |
| Sprint 4 | Implementação parcial e evidências | Semana 9-10 |
| Sprint 5 | Resultados e análise | Semana 11-12 |
| Sprint 6 | Versão final e apresentação | Semana 13-14 |

---

> *Documento sujeito a revisão e atualização ao longo do semestre.*
