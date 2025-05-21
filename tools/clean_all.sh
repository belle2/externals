#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "Removing top-level build artifacts..."
dirs_to_remove=(build include share Linux_x86_64)
for dir in "${dirs_to_remove[@]}"; do
    if [ -d "${dir}" ]; then
        echo "Deleting ${dir}..."
        rm -rf "${dir}" &
    fi
done

# Wait until all the processes from above are completed
wait

echo "Cleaning up src/ subdirectories..."
find src/ -mindepth 1 -maxdepth 1 -type d \
    ! -name "python-packages" \
    -print0 | xargs -0 -P4 -I{} bash -c 'echo "Deleting {}"; rm -rf "{}"'

echo "Cleanup completed."
