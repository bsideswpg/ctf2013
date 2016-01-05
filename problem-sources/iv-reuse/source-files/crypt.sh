#!/bin/sh

encryption_key="a93e7930862b4f02"

openssl enc -e -aes-128-ofb -K $encryption_key -iv 0000000000000000 < "$1" > "$1".enc
