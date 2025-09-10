#!/bin/sh

set -e
# timeout 30s python heavy_data_test.py
timeout --signal=TERM 10s python main.py
status=$?

if [ $status -eq 124 ]; then 
    echo "Timed out after 10s" >&2
    exit 124
else 
    echo "Other status: $status" >&2
    exit $status
fi