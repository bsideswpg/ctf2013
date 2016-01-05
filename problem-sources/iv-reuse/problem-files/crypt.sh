#!/bin/sh

# Not the actual encryption key ;)
encryption_key="XXXXXXXXXXXXXXXX"

openssl enc -e -aes-128-ofb -K $encryption_key -iv 0000000000000000 < "$1" > "$1".enc
