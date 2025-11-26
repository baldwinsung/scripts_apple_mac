printf "\nreset proxies...\n"
./reset_proxies.bash
./status_proxies.bash

printf "\napply proxies...\n"
./apply_pac_all.bash

printf "\ntoggle proxies...\n"
./toggle_proxyautoconfig.bash off
./toggle_proxyautoconfig.bash on
./status_proxies.bash

printf "\ntest proxies...\n"
./test_proxies.bash
