#!/bin/bash

#create key directly 

#KEY_PATH="$HOME/.ssh/ed25519"
#ssh-keygen -t ed25519 -f "$KEY_PATH" -N "" -C "bharath814@gmail.com" -q

#set -x # start debugging

#check the folder for exiting key before creating key 
KEY_PATH="$HOME/.ssh/ed25519"
if [ -f "$KEY_PATH" ]; then
	echo "key already exist in $(whoami)@$(hostname)"
else 
	echo "generating new key on $(date)"
	ssh-keygen -t ed25519 -f "$KEY_PATH" -N "" -C "bharath814@gmail.com" -q
	echo "new key generated, check in "$KEY_PATH" location"
fi

chmod 600 "$KEY_PATH"
chmod 600 "$KEY_PATH.pub"
