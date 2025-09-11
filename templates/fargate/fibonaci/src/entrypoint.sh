#!/bin/sh

set -e

# Max timeout
MAX_TIMEOUT=${MAX_TIMEOUT:-15m} # Default to 15 minutes
# timeout 30s python heavy_data_test.py
timeout --signal=TERM $MAX_TIMEOUT python -u main.py
status=$?

if [ $status -eq 124 ]; then 
    echo "Timed out after $MAX_TIMEOUT" >&2
    exit 124
else 
    echo "Other status: $status" >&2
    exit $status
fi