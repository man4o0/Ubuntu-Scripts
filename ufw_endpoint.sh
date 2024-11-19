#!/bin/bash
### This script is baseline for a good cybersecurity practice for Ubuntu systems. Every machine should have UFW enabled with default rules. ###

UFW_STATUS_VERBOSE=$(sudo ufw status verbose)

function enable_ufw {
  sudo ufw enable
}

function reload_ufw {
  sudo ufw reload
}

function modify_default_rules {
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
}

function add_ufw_rules {
  sudo ufw allow from ::1 comment "Allowing IPv6 localhost traffic"
  sudo ufw allow from 127.0.0.0/8 comment "Allowing localhost traffic"
}

if [[ $UFW_STATUS_VERBOSE == *'Status: inactive' ]]; then
  echo "Enabling UFW"
  enable_ufw
  UFW_STATUS_VERBOSE=$(sudo ufw status verbose)
else
  echo "UFW is enabled. Checking for rules"
  fi

add_ufw_rules

default_incoming=$(echo "$UFW_STATUS_VERBOSE" | grep "Default:" | awk '{print $2}' | tr -d '()') # deny
default_outgoing=$(echo "$UFW_STATUS_VERBOSE" | grep "Default:" | awk '{print $4}' | tr -d '()') # allow
if [ "$default_incoming" == "deny" ] && [ "$default_outgoing" == "allow" ]; then
  echo "Skipping adding existing default rules"
else
  modify_default_rules
fi

current_time=$(date +"%H:%M")
modified_file_time=$(date -r /etc/ufw/ufw.conf +"%H:%M")
if [[ "$current_time" == "$modified_file_time" ]]; then
  reload_ufw
  fi
  
