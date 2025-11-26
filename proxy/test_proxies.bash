#!/bin/bash

echo "=== Test proxies via nscurl ==="

# Get current IP via nscurl
PROXY=$(nscurl http://myip.baldwinsung.com 2>/dev/null)

# Validate if PROXY is a valid IPv4
if [[ $PROXY =~ ^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$ ]]; then
    echo "$PROXY is a valid IPv4."
    host $PROXY

    # Step 1: Get referral WHOIS server
    REFERRAL=$(whois -h whois.arin.net "$PROXY" \
        | awk -F': *' '/ReferralServer:/ {print $2}' \
        | sed 's|whois://||')

    if [[ -n "$REFERRAL" ]]; then
        echo "Referral server found: $REFERRAL"

        # Step 2: Query referral WHOIS
        WHOIS_DATA=$(whois -h "$REFERRAL" "$PROXY")

        # Step 3: Extract inetnum + org-name
        INETNUM=$(echo "$WHOIS_DATA" | awk -F': *' '/inetnum:/ {print $2}')
        ORGNAME=$(echo "$WHOIS_DATA" | awk -F': *' '/org-name:/ {print $2}')

        echo "Proxy IP:   $PROXY"
        echo "Referral:   $REFERRAL"
        echo "Inetnum:    $INETNUM"
        echo "Org-name:   $ORGNAME"
    else
        echo "No referral server found, falling back to ARIN"

        WHOIS_DATA=$(whois -h whois.arin.net "$PROXY")
        NETRANGE=$(echo "$WHOIS_DATA" | awk -F': *' '/NetRange:/ {print $2}')
        ORGNAME=$(echo "$WHOIS_DATA" | awk -F': *' '/OrgName:/ {print $2}')

        echo "Proxy IP:   $PROXY"
        echo "NetRange:   $NETRANGE"
        echo "Org-name:   $ORGNAME"
    fi

else
    echo "NOT IPv4: $PROXY"
fi
