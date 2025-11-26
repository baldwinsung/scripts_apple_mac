#!/bin/bash

echo "=== Resetting ALL macOS proxy settings (runtime + persistent) ==="

# Reset runtime proxy state
sudo scutil << EOF
open
d.init
set State:/Network/Global/Proxies
close
EOF

# Reset all network services
services=$(networksetup -listallnetworkservices | tail -n +2)

while IFS= read -r svc; do
    echo "Resetting $svc"
    sudo networksetup -setwebproxystate "$svc" off
    sudo networksetup -setsecurewebproxystate "$svc" off
    sudo networksetup -setsocksfirewallproxystate "$svc" off
    sudo networksetup -setautoproxystate "$svc" off
    sudo networksetup -setproxybypassdomains "$svc" ""
done <<< "$services"

echo "=== Proxy reset complete ==="
