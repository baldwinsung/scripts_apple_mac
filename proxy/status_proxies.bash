#!/bin/bash

echo "=== scutil runtime proxy state ==="
scutil --proxy
echo

echo "=== Network service proxy states ==="
services=$(networksetup -listallnetworkservices | tail -n +2)

while IFS= read -r svc; do
    echo "----- $svc -----"
    networksetup -getautoproxyurl "$svc" 2>/dev/null
    networksetup -getwebproxy "$svc" 2>/dev/null
    networksetup -getsecurewebproxy "$svc" 2>/dev/null
    networksetup -getsocksfirewallproxy "$svc" 2>/dev/null
    echo
done <<< "$services"
