# Plano de Backup e Continuidade (BCP/DRP) — VitaClínica

> Projeto Integrado II — Tecnologia em Análise e Desenvolvimento de Sistemas (TADS)
> Semestre 1/2026 | Professor Roberto Maia

---

## Descrição do Projeto

Este projeto elabora um **Plano de Backup** e um **Plano de Continuidade de Negócios / Recuperação de Desastres (BCP/DRP)** para a **VitaClínica**, uma clínica médica fictícia de médio porte com duas unidades no interior de São Paulo.

A VitaClínica gerencia prontuários eletrônicos, agendamentos, financeiro e comunicação interna em uma infraestrutura distribuída entre as duas unidades. Dado o volume de dados sensíveis de pacientes — sujeitos à LGPD — e a criticidade da continuidade operacional em um ambiente de saúde, a definição de estratégias robustas de backup e recuperação é essencial para a organização.

---

## Integrantes do Grupo

| Nome | Papel |
|------|-------|
| Filipe Oliveira Crepaldi dos Santos | Líder do Sprint |
| Bruno Vila | Responsável pela Documentação ABNT |
| Guilherme Maciel | Responsável Técnico |
| Rafael | Responsável por Evidências |
| Yan | Apoio Técnico e Revisão |

---

## Estrutura do Repositório

```
/
├── docs/           → Relatório ABNT, plano inicial e documentação do projeto
├── evidencias/     → Diagramas, tabelas de ativos, prints e artefatos técnicos
├── scripts/        → Scripts de automação e exemplos de configuração referenciados no plano
├── src/            → Código-fonte (se aplicável)
└── README.md       → Este arquivo
```

---

## Como Usar este Repositório

```bash
# 1. Clone o repositório
git clone <url-do-repositorio>

# 2. Acesse a documentação principal
cd docs/

# 3. Consulte as evidências técnicas
cd evidencias/
```

---

## Documentos Principais

| Documento | Localização |
|-----------|-------------|
| Plano Inicial do Projeto | `docs/plano_inicial.md` |
| Relatório ABNT | `docs/relatorio_abnt.docx` |
| Plano de Backup | `docs/plano_backup.md` |
| Plano BCP/DRP | `docs/plano_bcpdrp.md` |
| Diagrama de Arquitetura | `evidencias/diagrama_arquitetura.png` |

---

> *Projeto acadêmico — TADS | 2026*
