#!/bin/bash
for study in "5a69fef03623a3000e630ecd" "5a69ff083623a3000d63408d"; do
  echo "=== Checking folder $study ==="
  curl -s "https://api.osf.io/v2/nodes/6bwmq/files/osfstorage/$study/" | python3 -c "import sys, json; data = json.load(sys.stdin); [print('  ', f['attributes']['name'], '|', f['links'].get('download', 'N/A')) for f in data['data']]"
  echo
done
