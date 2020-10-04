#!/bin/bash

# T&M Hansson IT AB © - 2020, https://www.hanssonit.se/

# shellcheck disable=2034,2059
true
SCRIPT_NAME="Locales"
# shellcheck source=lib.sh
. ../lib.sh

# Must be root
root_check

# Set locales
sudo locale-gen "de_DE.UTF-8" && sudo dpkg-reconfigure --frontend=noninteractive locales
print_text_in_color "$ICyan" "Setting locales to de_DE"

# TODO: "localectl list-x11-keymap-layouts" and pair with "cat /etc/locale.gen | grep UTF-8"
