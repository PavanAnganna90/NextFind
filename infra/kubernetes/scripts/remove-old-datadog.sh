#!/bin/bash

# ==================================================================================================
# REMOVE OLD DATADOG MANIFESTS SCRIPT
# ==================================================================================================
# Purpose: Remove old Datadog Kubernetes manifests that are replaced by Helm chart
# Usage: ./remove-old-datadog.sh [--dry-run]
# ==================================================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONITORING_DIR="${SCRIPT_DIR}/../monitoring"
DRY_RUN=false

# Parse arguments
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${YELLOW}🔍 DRY RUN MODE - No files will be deleted${NC}"
    echo ""
fi

# Files to remove
FILES_TO_REMOVE=(
    "datadog.yaml"
    "datadog-operator.yaml"
    "datadog-agent-cr.yaml"
    "datadog-agent-simple-cr.yaml"
    "datadog-cluster-agent.yaml"
    "datadog-simple.yaml"
    "deploy-datadog-operator.sh"
)

echo -e "${BLUE}🗑️  Removing Old Datadog Manifests${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""

# Check if monitoring directory exists
if [ ! -d "$MONITORING_DIR" ]; then
    echo -e "${RED}❌ Error: Monitoring directory not found: ${MONITORING_DIR}${NC}"
    exit 1
fi

cd "$MONITORING_DIR"

# Remove files
REMOVED_COUNT=0
SKIPPED_COUNT=0

for file in "${FILES_TO_REMOVE[@]}"; do
    file_path="${MONITORING_DIR}/${file}"
    
    if [ -f "$file_path" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo -e "${YELLOW}📄 Would remove: ${file}${NC}"
            REMOVED_COUNT=$((REMOVED_COUNT + 1))
        else
            rm -f "$file_path"
            echo -e "${GREEN}✅ Removed: ${file}${NC}"
            REMOVED_COUNT=$((REMOVED_COUNT + 1))
        fi
    else
        echo -e "${BLUE}⏭️  Skipped (not found): ${file}${NC}"
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
    fi
done

echo ""
echo -e "${BLUE}=================================${NC}"
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}📊 Dry Run Summary:${NC}"
    echo -e "  Files to remove: ${REMOVED_COUNT}"
    echo -e "  Files not found: ${SKIPPED_COUNT}"
    echo ""
    echo -e "${YELLOW}💡 Run without --dry-run to actually remove files${NC}"
else
    echo -e "${GREEN}✅ Removal Complete${NC}"
    echo -e "  Files removed: ${REMOVED_COUNT}"
    echo -e "  Files not found: ${SKIPPED_COUNT}"
    echo ""
    echo -e "${YELLOW}⚠️  Note: Also check kustomization.yaml files for references to these files${NC}"
fi

echo ""




