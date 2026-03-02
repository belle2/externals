#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "Cleaning up build/, include/, share/, src/, ${BELLE2_ARCH}/ ..."

DIRS_TO_REMOVE=(build include share src ${BELLE2_ARCH})
for DIR in "${DIRS_TO_REMOVE[@]}"; do
    if [ -d "${DIR}" ]; then
        echo "Deleting ${DIR}..."
        rm -rf "${DIR}" &
    fi
done

# Wait until all the processes from above are completed
wait

echo "Cleanup completed."
