#!/bin/bash
# =============================================================================
# build-client-pack.sh - Build client modpack ZIP for players
# =============================================================================
# Merges server mods (mods/) + client-only mods (mods-client/) into a single
# ZIP archive that players can extract into their Minecraft instance.
#
# Usage: ./deploy/build-client-pack.sh [revision]
# Example: ./deploy/build-client-pack.sh        →  builds/kibermine-mods-22-02-26.zip
#          ./deploy/build-client-pack.sh v2      →  builds/kibermine-mods-22-02-26-v2.zip
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load logging library
source "$SCRIPT_DIR/lib/logging.sh"

# Directories
MODS_SERVER="$PROJECT_DIR/mods"
MODS_CLIENT="$PROJECT_DIR/mods-client"
BUILDS_DIR="$PROJECT_DIR/builds"

# -----------------------------------------------------------------------------
# Build filename: kibermine-mods-DD-MM-YY[-revision].zip
# -----------------------------------------------------------------------------
DATE_STAMP=$(date +%d-%m-%y)
REVISION="${1:-}"

if [[ -n "$REVISION" ]]; then
    OUTPUT_FILE="$BUILDS_DIR/kibermine-mods-${DATE_STAMP}-${REVISION}.zip"
else
    OUTPUT_FILE="$BUILDS_DIR/kibermine-mods-${DATE_STAMP}.zip"
fi

# -----------------------------------------------------------------------------
# Validation
# -----------------------------------------------------------------------------
print_header "KIBERmine Client Modpack Builder"

start_timer
init_steps 4

# Step 1: Validate source directories
log_step "Validating source directories"

if [[ ! -d "$MODS_SERVER" ]]; then
    die "Server mods directory not found: $MODS_SERVER"
fi
if [[ ! -d "$MODS_CLIENT" ]]; then
    die "Client mods directory not found: $MODS_CLIENT"
fi

SERVER_COUNT=$(find "$MODS_SERVER" -maxdepth 1 -name '*.jar' | wc -l | tr -d ' ')
CLIENT_COUNT=$(find "$MODS_CLIENT" -maxdepth 1 -name '*.jar' | wc -l | tr -d ' ')

log_substep "Server mods (mods/): $SERVER_COUNT" "ok"
log_substep_last "Client mods (mods-client/): $CLIENT_COUNT" "ok"

if [[ $SERVER_COUNT -eq 0 ]]; then
    die "No server mods found in $MODS_SERVER"
fi

# Step 2: Prepare temporary directory
log_step "Assembling modpack"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

PACK_DIR="$TMPDIR/mods"
mkdir -p "$PACK_DIR"

# Copy server mods
cp "$MODS_SERVER"/*.jar "$PACK_DIR/"
log_substep "Copied $SERVER_COUNT server mods" "ok"

# Copy client-only mods
if [[ $CLIENT_COUNT -gt 0 ]]; then
    cp "$MODS_CLIENT"/*.jar "$PACK_DIR/"
    log_substep "Copied $CLIENT_COUNT client-only mods" "ok"
fi

TOTAL_COUNT=$(find "$PACK_DIR" -maxdepth 1 -name '*.jar' | wc -l | tr -d ' ')
log_substep_last "Total mods in pack: $TOTAL_COUNT" "ok"

# Step 3: Create ZIP archive
log_step "Creating ZIP archive"

mkdir -p "$BUILDS_DIR"

# Remove existing file if present
[[ -f "$OUTPUT_FILE" ]] && rm -f "$OUTPUT_FILE"

# Create zip from temp directory (so paths inside zip start with mods/)
(cd "$TMPDIR" && zip -r -q "$OUTPUT_FILE" mods/)

ARCHIVE_SIZE=$(get_file_size "$OUTPUT_FILE")
log_substep "Archive: $(basename "$OUTPUT_FILE")" "ok"
log_substep_last "Size: $(format_bytes "$ARCHIVE_SIZE")" "ok"

# Step 4: Summary
log_step "Pack contents"

log_substep "Server mods: $SERVER_COUNT"
log_substep "Client-only mods: $CLIENT_COUNT"
log_substep "Total: $TOTAL_COUNT"
log_substep_last "Output: $OUTPUT_FILE"

print_footer "success" "$(get_elapsed)" "Mods: $TOTAL_COUNT | Size: $(format_bytes "$ARCHIVE_SIZE")"
