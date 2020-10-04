#!/bin/bash
# shellcheck disable=2034,2059
true
SCRIPT_NAME="Add CLI User"
# shellcheck source=lib.sh
. lib.sh

# T&M Hansson IT AB © - 2020, https://www.hanssonit.se/

# Check for errors + debug code and abort if something isn't right
# 1 = ON
# 0 = OFF
DEBUG=0
debug_mode

# FFT: Added configuration of AWS toolchain
AWS_ACCESS_KEY_ID=$(cat ~/.AWS_ACCESS_KEY_ID)
AWS_SECRET_ACCESS_KEY=$(cat ~/.AWS_SECRET_ACCESS_KEY)
AWS_DEFAULT_REGION=$(cat ~/.AWS_DEFAULT_REGION)
aws configure set AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID
aws configure set AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_DEFAULT_REGION

AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/)
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id/)
LINUX_USER_NAME=$(aws ec2 describe-tags --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`LINUX_USER_NAME`].Value' --output text)
LINUX_USER_PASS=$(aws ec2 describe-tags --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`LINUX_USER_PASS`].Value' --output text)
echo "Trying to setup Linux user $LINUX_USER_NAME with password $LINUX_USER_PASS"

# if [[ $UNIXUSER != "ncadmin" ]]
# then
# msg_box "Current user with sudo permissions is: $UNIXUSER.
# This script will set up everything with that user.
# If the field after ':' is blank you are probably running as a pure root user.
# It's possible to install with root, but there will be minor errors.

# Please create a user with sudo permissions if you want an optimal installation.
# The preferred user is 'ncadmin'."
    # if ! yesno_box_yes "Do you want to create a new user?"
    # then
        # print_text_in_color "$ICyan" "Not adding another user..."
        # sleep 1
    # else
        # FFT: No need for interactive name/password, just grab from EC2 tag
        # read -r -p "Enter name of the new user: " NEWUSER
        adduser --disabled-password --gecos "" "$LINUX_USER_NAME"
        sudo usermod -aG sudo "$LINUX_USER_NAME"
        usermod -s /bin/bash "$LINUX_USER_NAME"
        echo "$LINUX_USER_PASS" | passwd "$LINUX_USER_NAME" --stdin
        # while :
        # do
        #     sudo passwd "$NEWUSER" && break
        # done
        sudo -u "$LINUX_USER_NAME" sudo bash "$1"
    # fi
# fi
