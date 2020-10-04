#!/bin/bash

# T&M Hansson IT AB © - 2020, https://www.hanssonit.se/

# shellcheck disable=2034,2059
true
SCRIPT_NAME="Locales"
# shellcheck source=lib.sh
. lib.sh

# Must be root
root_check

# FFT: Added configuration of AWS toolchain
AWS_ACCESS_KEY_ID=$(cat ~/.AWS_ACCESS_KEY_ID)
AWS_SECRET_ACCESS_KEY=$(cat ~/.AWS_SECRET_ACCESS_KEY)
AWS_DEFAULT_REGION=$(cat ~/.AWS_DEFAULT_REGION)
aws configure set AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID
aws configure set AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_DEFAULT_REGION

AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id/)
LOCALE=$(aws ec2 describe-tags --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`LOCALE`].Value' --output text)

# Set locales
sudo locale-gen "$LOCALE.UTF-8" && sudo dpkg-reconfigure --frontend=noninteractive locales
print_text_in_color "$ICyan" "Setting locales to de_DE"

# TODO: "localectl list-x11-keymap-layouts" and pair with "cat /etc/locale.gen | grep UTF-8"
