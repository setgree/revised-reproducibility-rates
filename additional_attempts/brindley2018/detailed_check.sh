#!/bin/bash

echo "=== Checking Gibson 2014 folders ==="
curl -s "https://api.osf.io/v2/nodes/8q769/files/" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for item in data['data']:
    provider = item['attributes']['provider']
    print(f'Provider: {provider}')
    files_link = item['relationships']['files']['links']['related']['href']
    print(f'Files link: {files_link}')
" 2>&1

echo -e "\n=== Quick summary of all remaining papers ==="
for node in "8q769" "h4qgx" "snmpz"; do
    echo "Node $node:"
    curl -s "https://api.osf.io/v2/nodes/$node/" | python3 -c "import sys, json; d=json.load(sys.stdin); print('  Title:', d.get('data', {}).get('attributes', {}).get('title', 'N/A'))" 2>&1 || echo "  Error accessing node"
done
