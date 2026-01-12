#!/bin/bash
echo "=== Gibson 2014 (8q769) ==="
curl -s "https://api.osf.io/v2/nodes/8q769/files/osfstorage/" | python3 -c "import sys, json; data = json.load(sys.stdin); [print('  ', f['attributes']['name'], '|', f['attributes']['kind']) for f in data['data']]"

echo -e "\n=== Soliman 2017 (h4qgx) ==="
curl -s "https://api.osf.io/v2/nodes/h4qgx/files/osfstorage/" | python3 -c "import sys, json; data = json.load(sys.stdin); [print('  ', f['attributes']['name'], '|', f['attributes']['kind']) for f in data['data']]"
