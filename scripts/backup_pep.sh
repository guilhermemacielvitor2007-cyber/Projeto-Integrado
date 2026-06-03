#!/bin/bash
# =============================================================================
# backup_pep.sh — VitaClínica
# Backup automatizado do Servidor PEP e Banco de Dados de Pacientes
# Implementa a Regra 3-2-1: NAS local (Cópia 1) + Amazon S3 (Cópia 2)
# A Cópia 3 (HD off-site) é realizada manualmente com rotação semanal.
# =============================================================================

set -euo pipefail

# =============================================================================
# CONFIGURAÇÕES
# =============================================================================
BACKUP_SOURCE_PEP="/opt/vitaclinica/pep"
BACKUP_SOURCE_DB="/var/lib/postgresql/vitaclinica"

NAS_MOUNT="/mnt/nas"
NAS_BACKUP_DIR="${NAS_MOUNT}/backups/pep"
NAS_SNAPSHOTS_DIR="${NAS_BACKUP_DIR}/snapshots"

CLOUD_BUCKET="s3://vitaclinica-backups"
CLOUD_PREFIX="pep/snapshots"

ENCRYPTION_KEY_FILE="/etc/vitaclinica/backup.key"

RETENTION_DAYS=90
LOG_DIR="/var/log/vitaclinica"
LOG_FILE="${LOG_DIR}/backup_pep.log"

DATE_TAG=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="pep_backup_${DATE_TAG}"

# =============================================================================
# FUNÇÕES AUXILIARES
# =============================================================================

log() {
    local level="$1"
    local message="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] ${message}" | tee -a "$LOG_FILE"
}

check_prerequisites() {
    log "INFO" "Verificando pré-requisitos..."

    if ! mountpoint -q "$NAS_MOUNT"; then
        log "ERROR" "NAS não está montado em ${NAS_MOUNT}. Abortando."
        exit 1
    fi

    if [ ! -f "$ENCRYPTION_KEY_FILE" ]; then
        log "ERROR" "Chave de criptografia não encontrada: ${ENCRYPTION_KEY_FILE}. Abortando."
        exit 1
    fi

    for cmd in rsync tar openssl aws sha256sum; do
        if ! command -v "$cmd" &>/dev/null; then
            log "ERROR" "Comando não encontrado: ${cmd}. Instale antes de executar."
            exit 1
        fi
    done

    mkdir -p "$NAS_SNAPSHOTS_DIR" "$LOG_DIR"
    log "INFO" "Pré-requisitos verificados com sucesso."
}

generate_checksum() {
    local file="$1"
    sha256sum "$file" | awk '{print $1}'
}

# =============================================================================
# CÓPIA 1 — BACKUP LOCAL (NAS)
# =============================================================================

backup_local_incremental() {
    log "INFO" "Iniciando backup incremental local (Cópia 1 — NAS)..."

    # Sincronização incremental contínua via rsync
    rsync -az --delete --checksum \
        --log-file="$LOG_FILE" \
        "${BACKUP_SOURCE_PEP}/" \
        "${NAS_BACKUP_DIR}/current_pep/"

    rsync -az --delete --checksum \
        --log-file="$LOG_FILE" \
        "${BACKUP_SOURCE_DB}/" \
        "${NAS_BACKUP_DIR}/current_db/"

    log "INFO" "Sincronização incremental concluída."
}

backup_local_snapshot() {
    log "INFO" "Criando snapshot comprimido para ${BACKUP_NAME}..."

    local TARBALL="${NAS_SNAPSHOTS_DIR}/${BACKUP_NAME}.tar.gz"
    local ENCRYPTED="${NAS_SNAPSHOTS_DIR}/${BACKUP_NAME}.tar.gz.enc"
    local CHECKSUM_FILE="${NAS_SNAPSHOTS_DIR}/${BACKUP_NAME}.sha256"

    # Criar tarball comprimido do PEP e do banco de dados
    tar -czf "$TARBALL" \
        -C "$(dirname $BACKUP_SOURCE_PEP)" "$(basename $BACKUP_SOURCE_PEP)" \
        -C "$(dirname $BACKUP_SOURCE_DB)" "$(basename $BACKUP_SOURCE_DB)"

    # Criptografar com AES-256
    openssl enc -aes-256-cbc -salt -pbkdf2 -iter 100000 \
        -in "$TARBALL" \
        -out "$ENCRYPTED" \
        -pass "file:${ENCRYPTION_KEY_FILE}"

    # Gerar checksum SHA-256 do arquivo criptografado
    generate_checksum "$ENCRYPTED" > "$CHECKSUM_FILE"
    log "INFO" "Checksum SHA-256: $(cat $CHECKSUM_FILE)"

    # Remover tarball não criptografado
    rm -f "$TARBALL"

    log "INFO" "Snapshot local criado: ${BACKUP_NAME}.tar.gz.enc"
}

# =============================================================================
# CÓPIA 2 — BACKUP EM NUVEM (AMAZON S3)
# =============================================================================

backup_cloud() {
    log "INFO" "Iniciando envio para Amazon S3 (Cópia 2 — Nuvem)..."

    local ENCRYPTED="${NAS_SNAPSHOTS_DIR}/${BACKUP_NAME}.tar.gz.enc"
    local CHECKSUM_FILE="${NAS_SNAPSHOTS_DIR}/${BACKUP_NAME}.sha256"

    # Enviar snapshot criptografado para o S3
    aws s3 cp "$ENCRYPTED" \
        "s3://${CLOUD_BUCKET}/${CLOUD_PREFIX}/${BACKUP_NAME}.tar.gz.enc" \
        --sse AES256 \
        --storage-class STANDARD_IA \
        --metadata "checksum=$(cat $CHECKSUM_FILE),date=${DATE_TAG}"

    # Enviar arquivo de checksum
    aws s3 cp "$CHECKSUM_FILE" \
        "s3://${CLOUD_BUCKET}/${CLOUD_PREFIX}/${BACKUP_NAME}.sha256"

    log "INFO" "Backup enviado para S3 com sucesso: s3://${CLOUD_BUCKET}/${CLOUD_PREFIX}/${BACKUP_NAME}.tar.gz.enc"
}

# =============================================================================
# LIMPEZA — REMOÇÃO DE BACKUPS ANTIGOS
# =============================================================================

cleanup_old_backups() {
    log "INFO" "Removendo snapshots locais com mais de ${RETENTION_DAYS} dias..."
    find "$NAS_SNAPSHOTS_DIR" -name "*.enc" -mtime "+${RETENTION_DAYS}" -delete
    find "$NAS_SNAPSHOTS_DIR" -name "*.sha256" -mtime "+${RETENTION_DAYS}" -delete
    log "INFO" "Limpeza de backups locais concluída."
}

# =============================================================================
# VERIFICAÇÃO DE INTEGRIDADE (usado na rotina de testes)
# =============================================================================

verify_backup_integrity() {
    local ENCRYPTED="${NAS_SNAPSHOTS_DIR}/${BACKUP_NAME}.tar.gz.enc"
    local CHECKSUM_FILE="${NAS_SNAPSHOTS_DIR}/${BACKUP_NAME}.sha256"
    local EXPECTED_CHECKSUM
    local ACTUAL_CHECKSUM

    EXPECTED_CHECKSUM=$(cat "$CHECKSUM_FILE")
    ACTUAL_CHECKSUM=$(generate_checksum "$ENCRYPTED")

    if [ "$EXPECTED_CHECKSUM" = "$ACTUAL_CHECKSUM" ]; then
        log "INFO" "Verificação de integridade: OK (SHA-256 confere)"
    else
        log "ERROR" "Verificação de integridade: FALHA — checksum divergente!"
        log "ERROR" "Esperado:  ${EXPECTED_CHECKSUM}"
        log "ERROR" "Calculado: ${ACTUAL_CHECKSUM}"
        exit 1
    fi
}

# =============================================================================
# NOTIFICAÇÃO (integração com Zabbix — descomente para ativar)
# =============================================================================

send_notification() {
    local status="$1"
    local message="$2"
    log "INFO" "Notificação [${status}]: ${message}"
    # zabbix_sender -z zabbix-server.vitaclinica.local \
    #     -s "vitaclinica-pep" \
    #     -k backup.status \
    #     -o "${status}"
}

# =============================================================================
# MAIN
# =============================================================================

log "INFO" "============================================================"
log "INFO" "Iniciando processo de backup — VitaClínica PEP"
log "INFO" "Backup: ${BACKUP_NAME}"
log "INFO" "============================================================"

check_prerequisites

# CÓPIA 1: NAS local
if backup_local_incremental && backup_local_snapshot; then
    log "INFO" "✔ Cópia 1 (NAS local) — CONCLUÍDA COM SUCESSO"
    verify_backup_integrity
    send_notification "OK" "Backup local do PEP concluído: ${BACKUP_NAME}"
else
    log "ERROR" "✘ Cópia 1 (NAS local) — FALHA"
    send_notification "FAIL" "FALHA no backup local do PEP: ${BACKUP_NAME}"
    exit 1
fi

# CÓPIA 2: Amazon S3
if backup_cloud; then
    log "INFO" "✔ Cópia 2 (Amazon S3) — CONCLUÍDA COM SUCESSO"
    send_notification "OK" "Backup em nuvem do PEP concluído: ${BACKUP_NAME}"
else
    log "WARN" "✘ Cópia 2 (Amazon S3) — FALHA (verificar conectividade)"
    send_notification "WARN" "FALHA no backup em nuvem do PEP: ${BACKUP_NAME}"
    # Não abortar — o backup local foi concluído com sucesso
fi

# Limpeza de backups antigos
cleanup_old_backups

log "INFO" "============================================================"
log "INFO" "Processo de backup concluído — ${BACKUP_NAME}"
log "INFO" "Cópia 3 (HD off-site): realizar rotação manual conforme"
log "INFO" "cronograma semanal definido no Plano de Backup."
log "INFO" "============================================================"
