# Plano de Backup e Continuidade de Negócios (BCP/DRP) — VitaClínica

> **Projeto Integrado II** — Tecnologia em Análise e Desenvolvimento de Sistemas (TADS)
> Anhanguera | Semestre 1/2026 | Professor Roberto Maia

---

## Sobre o Projeto

Este repositório contém o **Plano de Backup e Continuidade de Negócios (BCP/DRP)** desenvolvido para a **VitaClínica**, empresa fictícia que representa uma clínica médica de médio porte com duas unidades no interior de São Paulo (Unidade Central e Unidade Bairro).

O projeto cobre o ciclo completo de planejamento de continuidade: levantamento de riscos, definição de RPO/RTO, estratégia de backup com regra 3-2-1, procedimentos para três cenários de desastre, exercício de mesa simulado, análise de gaps, indicadores de desempenho e política de privacidade LGPD.

**Disciplina:** Projeto Integrado II — sem desenvolvimento de sistemas. Foco em documentação técnica e planejamento.

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

## Status dos Sprints

| Sprint | Status | Foco |
|--------|--------|------|
| Sprint 0 | ✅ Concluído | Estrutura inicial, plano preliminar, README |
| Sprint 1 | ✅ Concluído | Introdução ABNT, escopo, análise de riscos |
| Sprint 2 | ✅ Concluído | Fundamentação teórica, classificação de ativos, RPO/RTO |
| Sprint 3 | ✅ Concluído | Projeto técnico, backup 3-2-1, procedimentos dos 3 cenários |
| Sprint 4 | ✅ Concluído | Cronograma de implantação, RACI, comunicação, simulação de teste |
| Sprint 5 | ✅ Concluído | Resultados, análise de gaps, KPIs, plano de melhoria contínua |
| Sprint 6 | ✅ Concluído | Versão final, sumário executivo, política LGPD, slides |

---

## Estrutura do Repositório

```
Projeto-Integrado/
│
├── docs/                                      → Documentação técnica (formato ABNT)
│   ├── plano_inicial.md                       → Sprint 0: visão geral e escopo inicial
│   ├── sprint1_introducao_escopo_riscos.md    → Sprint 1: introdução, objetivos, análise de riscos
│   ├── sprint2_fundamentacao_requisitos.md    → Sprint 2: referencial teórico, ativos, RPO/RTO
│   ├── sprint3_projeto_tecnico.md             → Sprint 3: backup 3-2-1, cenários, plano de testes
│   ├── sprint4_implementacao_evidencias.md    → Sprint 4: RACI, comunicação, exercício de mesa
│   ├── sprint5_resultados_analise.md          → Sprint 5: análise de gaps, KPIs, melhoria contínua
│   └── sprint6_versao_final.md                → Sprint 6: sumário executivo, LGPD, referências finais
│
├── evidencias/                                → Diagramas SVG e ferramentas HTML
│   ├── diagrama_topologia.svg                 → Topologia da rede das duas unidades
│   ├── diagrama_fluxo_backup.svg              → Fluxo da estratégia de backup 3-2-1
│   ├── diagrama_fluxo_ativacao_bcp.svg        → Fluxo de ativação do BCP/DRP (3 cenários)
│   └── tabela_gap_analysis.svg                → Matriz de análise de gaps (6 ativos × 5 dimensões)
│
├── scripts/                                   → Scripts de automação (bash)
│   ├── backup_pep.sh                          → Backup automatizado do PEP com criptografia AES-256
│   └── teste_restauracao.sh                   → Teste mensal de restauração com validação SHA-256
│
├── src/                                       → Ferramentas interativas (código HTML/CSS/JS)
│   ├── guia_resposta_incidentes.html          → Guia interativo de resposta a incidentes
│   └── apresentacao_slides.html              → Apresentação de slides para a defesa (14 slides)
└── README.md                                  → Este arquivo
```

---

## Destaques Técnicos

### Ativos Críticos e Parâmetros de Recuperação

| Ativo | Descrição | RTO | RPO | Criticidade |
|-------|-----------|-----|-----|-------------|
| A01 — PEP | Prontuário Eletrônico do Paciente | 2 h | 1 h | Crítico |
| A02 — BD Pacientes | Banco de Dados de Pacientes | 2 h | 1 h | Crítico |
| A03 — Agendamento | Sistema de Agendamento | 4 h | 4 h | Alto |
| A04 — Financeiro | Sistema Financeiro | 8 h | 8 h | Médio |
| A05 — Laudos | Imagens Médicas (DICOM) | 4 h | 4 h | Alto |
| A06 — VPN | Interligação das Unidades | 2 h | N/A | Crítico |

### Estratégia de Backup — Regra 3-2-1

| Cópia | Local | Tecnologia | Tipo |
|-------|-------|-----------|------|
| Cópia 1 | NAS local (Synology DS223) | rsync + Veeam | On-site — incremental/hora, full/dia |
| Cópia 2 | Amazon S3 (sa-east-1) | AWS CLI | Nuvem — AES-256-CBC |
| Cópia 3 | HD externo (30+ km) | Rotação semanal | Off-site — guarda em local contratado |

### Cenários de Desastre Cobertos

| Cenário | Tipo | Prioridade | RTO | Testado |
|---------|------|-----------|-----|---------|
| AM01 | Falha de hardware | P1 | 2 h | ✅ Exercício de mesa 02/06/2026 |
| AM02 | Ransomware / Ciberataque | P1 | 8 h | Documentado — teste planejado set/2026 |
| AM03 | Incêndio / Desastre físico | P3 | 48–72 h | Documentado — teste planejado dez/2026 |

### Resultado do Exercício de Mesa (02/06/2026)

- **RPO obtido:** 47 min (meta: ≤ 1h) ✅
- **RTO obtido:** 2h05min (meta: ≤ 2h) — desvio de 5 min, corrigível ⚠
- **Integridade dos backups:** 100% dos checksums SHA-256 válidos ✅

---

## Como Navegar o Projeto

### Leitura sequencial recomendada (ordem dos sprints)

```
docs/plano_inicial.md
  → sprint1_introducao_escopo_riscos.md
  → sprint2_fundamentacao_requisitos.md
  → sprint3_projeto_tecnico.md
  → sprint4_implementacao_evidencias.md
  → sprint5_resultados_analise.md
  → sprint6_versao_final.md   ← Contém sumário executivo e conclusão final
```

### Apresentação para a defesa

Abrir no navegador:

```
src/apresentacao_slides.html
```

Navegação: **seta direita / clique** para avançar · **seta esquerda** para voltar · **Ctrl+P** para imprimir.

### Guia operacional de resposta a incidentes

```
src/guia_resposta_incidentes.html
```

Ferramenta interativa com checklists, cronômetro de RTO e modo de incidente.

### Scripts de automação

```bash
# Executar backup manual do PEP
sudo bash scripts/backup_pep.sh

# Executar teste de restauração mensal
sudo bash scripts/teste_restauracao.sh
```

> Os scripts requerem Linux/macOS com `openssl`, `rsync`, `tar` e `sha256sum` instalados. Em produção, devem ser adaptados com os caminhos e credenciais reais.

---

## Conformidade Normativa

| Norma / Legislação | Status |
|--------------------|--------|
| ABNT NBR ISO/IEC 27001:2013 | ~86% dos controles avaliados atendidos |
| ABNT NBR 15999-1:2007 | ~83% das seções avaliadas atendidas |
| NIST SP 800-34 Rev. 1 | Fases 1–6 concluídas (~86%) |
| LGPD — Lei nº 13.709/2018 (arts. 46, 48 e 50) | 100% atendidos |
| Requisitos do manual da disciplina | 100% atendidos |

---

## Referências Bibliográficas

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR ISO/IEC 27001:2013**. Rio de Janeiro: ABNT, 2013.

ASSOCIAÇÃO BRASILEIRA DE NORMAS TÉCNICAS. **ABNT NBR 15999-1:2007**. Rio de Janeiro: ABNT, 2007.

BRASIL. **Lei nº 13.709/2018** — Lei Geral de Proteção de Dados Pessoais (LGPD). Brasília: Presidência da República, 2018.

LYRA, Maurício Rocha. **Segurança e Auditoria em Sistemas de Informação**. Rio de Janeiro: Ciência Moderna, 2008.

NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY. **NIST SP 800-34 Rev. 1**. Gaithersburg: NIST, 2010.

SÊMOLA, Marcos. **Gestão da Segurança da Informação**: uma visão executiva. 2. ed. Rio de Janeiro: Elsevier, 2014.

---

> *Projeto acadêmico — TADS Anhanguera | Semestre 2/2026*
> *Todos os dados da VitaClínica (nomes, endereços, CNPJs, IPs) são fictícios.*
