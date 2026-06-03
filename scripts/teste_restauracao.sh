#!/bin/bash
# =============================================================================
# teste_restauracao.sh — VitaClínica
# Teste mensal automatizado de restauração de backup
#
# Localiza o snapshot mais recente no NAS, decripta em diretório de
# homologação isolado, valida checksum SHA-256 e verifica integridade básica
# do conteúdo restaurado. Gera relatório ao final.
#
# Execução: sudo bash teste_restauracao.sh
# Agendamento sugerido (cron): 0 8 1 * * /opt/vitaclinica/scripts/teste_restauracao.sh
# =============================================================================

set -euo pipefail

# =============================================================================
# CONFIGURAÇÕES
# =============================================================================
NAS_SNAPSHOTS_DIR="/mnt/nas/backups/pep/snapshots"
ENCRYPTION_KEY_FILE="/etc/vitaclinica/backup.key"
TEST_RESTORE_DIR="/tmp/vitaclinica_restore_test"
LOG_DIR="/var/log/vitaclinica"
LOG_FILE="${LOG_DIR}/teste_restauracao.log"
REPORT_DIR="${LOG_DIR}/relatorios_teste"
REPORT_FILE="${REPORT_DIR}/relatorio_teste_$(date +%Y%m%d_%H%M%S).txt"

EXPECTED_DIRS=("pep" "vitaclinica")   # Diretórios esperados após restauração
MIN_FILES=5                            # Mínimo de arquivos esperados no restore

# =============================================================================
# UTILITÁRIOS
# =============================================================================

log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] [${level}] ${message}" | tee -a "$LOG_FILE"
}

report() {
    echo "$1" | tee -a "$REPORT_FILE"
}

hr() {
    report "$(printf '%0.s-' {1..72})"
}

elapsed_since() {
    local start="$1"
    local end
    end=$(date +%s)
    echo $(( end - start ))
}

cleanup() {
    log "INFO" "Removendo diretório de teste: ${TEST_RESTORE_DIR}"
    rm -rf "$TEST_RESTORE_DIR"
}

# =============================================================================
# VERIFICAÇÃO DE PRÉ-REQUISITOS
# =============================================================================

check_prerequisites() {
    log "INFO" "Verificando pré-requisitos do teste..."

    if ! mountpoint -q "$(dirname "$NAS_SNAPSHOTS_DIR")"; then
        log "ERROR" "NAS não está montado. Verifique o mount antes de executar o teste."
        exit 1
    fi

    if [ ! -d "$NAS_SNAPSHOTS_DIR" ]; then
        log "ERROR" "Diretório de snapshots não encontrado: ${NAS_SNAPSHOTS_DIR}"
        exit 1
    fi

    if [ ! -f "$ENCRYPTION_KEY_FILE" ]; then
        log "ERROR" "Chave de criptografia não encontrada: ${ENCRYPTION_KEY_FILE}"
        exit 1
    fi

    for cmd in openssl sha256sum tar find; do
        if ! command -v "$cmd" &>/dev/null; then
            log "ERROR" "Comando necessário não encontrado: ${cmd}"
            exit 1
        fi
    done

    mkdir -p "$TEST_RESTORE_DIR" "$REPORT_DIR" "$LOG_DIR"
    log "INFO" "Pré-requisitos verificados com sucesso."
}

# =============================================================================
# LOCALIZAR BACKUP MAIS RECENTE
# =============================================================================

find_latest_backup() {
    log "INFO" "Procurando snapshot mais recente em ${NAS_SNAPSHOTS_DIR}..."

    local latest
    latest=$(find "$NAS_SNAPSHOTS_DIR" -name "*.tar.gz.enc" -type f \
             -printf '%T@ %p\n' 2>/dev/null \
             | sort -rn \
             | head -1 \
             | awk '{print $2}')

    if [ -z "$latest" ]; then
        log "ERROR" "Nenhum snapshot .tar.gz.enc encontrado em ${NAS_SNAPSHOTS_DIR}"
        exit 1
    fi

    echo "$latest"
}

# =============================================================================
# VERIFICAR CHECKSUM
# =============================================================================

verify_checksum() {
    local encrypted_file="$1"
    local checksum_file="${encrypted_file%.tar.gz.enc}.sha256"

    log "INFO" "Verificando checksum SHA-256 de: $(basename "$encrypted_file")"

    if [ ! -f "$checksum_file" ]; then
        log "WARN" "Arquivo de checksum não encontrado: ${checksum_file}"
        log "WARN" "Verificação de integridade ignorada (arquivo .sha256 ausente)."
        return 1
    fi

    local expected actual
    expected=$(cat "$checksum_file")
    actual=$(sha256sum "$encrypted_file" | awk '{print $1}')

    if [ "$expected" = "$actual" ]; then
        log "INFO" "Checksum SHA-256: OK"
        log "INFO" "  Esperado:  ${expected}"
        log "INFO" "  Calculado: ${actual}"
        return 0
    else
        log "ERROR" "FALHA NO CHECKSUM — arquivo pode estar corrompido!"
        log "ERROR" "  Esperado:  ${expected}"
        log "ERROR" "  Calculado: ${actual}"
        return 1
    fi
}

# =============================================================================
# DECRIPTAR PARA DIRETÓRIO DE TESTE
# =============================================================================

decrypt_backup() {
    local encrypted_file="$1"
    local decrypted_file="${TEST_RESTORE_DIR}/restore_test.tar.gz"

    log "INFO" "Decriptando backup para diretório de teste..."

    openssl enc -aes-256-cbc -d -pbkdf2 -iter 100000 \
        -in "$encrypted_file" \
        -out "$decrypted_file" \
        -pass "file:${ENCRYPTION_KEY_FILE}"

    if [ ! -f "$decrypted_file" ]; then
        log "ERROR" "Decriptação falhou — arquivo de saída não gerado."
        exit 1
    fi

    log "INFO" "Decriptação concluída: ${decrypted_file}"
    echo "$decrypted_file"
}

# =============================================================================
# EXTRAIR E VALIDAR CONTEÚDO
# =============================================================================

extract_and_validate() {
    local tarball="$1"
    local extract_dir="${TEST_RESTORE_DIR}/extracted"

    log "INFO" "Extraindo conteúdo do backup..."

    mkdir -p "$extract_dir"
    tar -xzf "$tarball" -C "$extract_dir" 2>>"$LOG_FILE"

    local file_count
    file_count=$(find "$extract_dir" -type f | wc -l)
    log "INFO" "Arquivos extraídos: ${file_count}"

    if [ "$file_count" -lt "$MIN_FILES" ]; then
        log "WARN" "Número de arquivos restaurados (${file_count}) abaixo do mínimo esperado (${MIN_FILES})."
        return 1
    fi

    local all_dirs_ok=true
    for expected_dir in "${EXPECTED_DIRS[@]}"; do
        if find "$extract_dir" -type d -name "$expected_dir" | grep -q .; then
            log "INFO" "Diretório esperado encontrado: ${expected_dir}"
        else
            log "WARN" "Diretório esperado NÃO encontrado: ${expected_dir}"
            all_dirs_ok=false
        fi
    done

    if $all_dirs_ok; then
        log "INFO" "Validação de conteúdo: OK (${file_count} arquivos, estrutura correta)"
        return 0
    else
        log "WARN" "Validação de conteúdo: PARCIAL (estrutura incompleta)"
        return 1
    fi
}

# =============================================================================
# GERAR RELATÓRIO DE TESTE
# =============================================================================

generate_report() {
    local backup_file="$1"
    local checksum_result="$2"
    local extract_result="$3"
    local total_seconds="$4"

    local status="APROVADO"
    if [ "$checksum_result" != "0" ] || [ "$extract_result" != "0" ]; then
        status="REPROVADO — GERAR RELATÓRIO DE NAO CONFORMIDADE (RNC)"
    fi

    hr
    report "RELATORIO DE TESTE DE RESTAURACAO — VitaClinica"
    hr
    report "Data/hora       : $(date '+%d/%m/%Y %H:%M:%S')"
    report "Backup testado  : $(basename "$backup_file")"
    report "Tamanho         : $(du -sh "$backup_file" 2>/dev/null | awk '{print $1}')"
    report "Tempo de teste  : ${total_seconds} segundos"
    hr
    report "Verificacao de checksum SHA-256 : $([ "$checksum_result" = "0" ] && echo "OK" || echo "FALHOU")"
    report "Extracao do backup              : $([ "$extract_result" = "0" ] && echo "OK" || echo "FALHOU")"
    report "Validacao de conteudo           : $([ "$extract_result" = "0" ] && echo "OK" || echo "ALERTA")"
    hr
    report "RESULTADO FINAL : ${status}"
    hr
    report "Arquivo de log completo: ${LOG_FILE}"
    report ""

    log "INFO" "Relatorio gerado: ${REPORT_FILE}"
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    local start_time
    start_time=$(date +%s)

    log "INFO" "============================================================"
    log "INFO" "Iniciando teste mensal de restauracao — VitaClinica PEP"
    log "INFO" "$(date '+%d/%m/%Y %H:%M:%S')"
    log "INFO" "============================================================"

    check_prerequisites

    local latest_backup
    latest_backup=$(find_latest_backup)
    log "INFO" "Backup selecionado para teste: $(basename "$latest_backup")"

    local checksum_ok=0
    verify_checksum "$latest_backup" || checksum_ok=1

    local decrypted_file
    decrypted_file=$(decrypt_backup "$latest_backup")

    local extract_ok=0
    extract_and_validate "$decrypted_file" || extract_ok=1

    local total_seconds
    total_seconds=$(elapsed_since "$start_time")

    generate_report "$latest_backup" "$checksum_ok" "$extract_ok" "$total_seconds"

    cleanup

    log "INFO" "Teste de restauracao concluido em ${total_seconds}s."

    if [ "$checksum_ok" -ne 0 ] || [ "$extract_ok" -ne 0 ]; then
        log "WARN" "Teste REPROVADO. Preencher Relatorio de Nao Conformidade (RNC)."
        exit 2
    fi

    log "INFO" "Teste APROVADO. Backup integro e restauravel."
    exit 0
}

main "$@"
