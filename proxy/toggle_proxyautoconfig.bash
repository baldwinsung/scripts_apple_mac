#!/bin/bash

export PAC_URL="$(cut -d= -f2 pac.conf)"

ACTION="$1"  # Get "on", "off", or empty for toggle

services=$(networksetup -listallnetworkservices | tail -n +2)

turn_on() {
    echo "=== Turning PAC ON ==="
    while IFS= read -r svc; do
        sudo networksetup -setautoproxyurl "$svc" "$PAC_URL"
        sudo networksetup -setautoproxystate "$svc" on
    done <<< "$services"

    sudo scutil << EOF
open
d.init
d.add ProxyAutoConfigEnable 1
d.add ProxyAutoConfigURLString "$PAC_URL"
set State:/Network/Global/Proxies
close
EOF

    echo "PAC enabled: $PAC_URL"
}

turn_off() {
    echo "=== Turning PAC OFF ==="
    while IFS= read -r svc; do
        sudo networksetup -setautoproxystate "$svc" off
    done <<< "$services"

    sudo scutil << EOF
open
get State:/Network/Global/Proxies
d.add ProxyAutoConfigEnable 0
remove ProxyAutoConfigURLString
set State:/Network/Global/Proxies
close
EOF

    echo "PAC disabled."
}

case "$ACTION" in
    on)
        turn_on
        ;;
    off)
        turn_off
        ;;
    "" )
        # No argument: toggle
        if scutil --proxy | grep -q "ProxyAutoConfigEnable : 1"; then
            turn_off
        else
            turn_on
        fi
        ;;
    *)
        echo "Usage: $0 [on|off]"
        exit 1
        ;;
esac
