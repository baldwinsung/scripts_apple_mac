#!/bin/bash

export PAC_URL="`cat pac.conf | cut -d= -f2`"

echo "=== Applying PAC to ALL interfaces ==="
echo "PAC URL: $PAC_URL"

services=$(networksetup -listallnetworkservices | tail -n +2)

while IFS= read -r svc; do
    echo "Configuring $svc"
    sudo networksetup -setautoproxyurl "$svc" "$PAC_URL"
    sudo networksetup -setautoproxystate "$svc" on
done <<< "$services"

echo "Updating global proxy runtime state..."
sudo scutil << EOF
open
d.init
d.add ProxyAutoConfigEnable 1
d.add ProxyAutoConfigURLString "$PAC_URL"
set State:/Network/Global/Proxies
close
EOF

echo "=== PAC applied to all services ==="
