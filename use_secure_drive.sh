#!/usr/bin/env bash

read -p "Key file>" KEY_FILE
read -p "Encrypted drive block device>" SRC_DRIVE

# Decrypt key file
openssl enc -aes-256-cbc -pbkdf2 -d -in "${KEY_FILE}" -out "drive.key"

# Open LUKS volume
sudo cryptsetup --key-file "drive.key" luksOpen "${SRC_DRIVE}" secure_data
rm -rf "drive.key"
