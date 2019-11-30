#!/usr/bin/env bash

lsblk
read -p "Drive name >" DRIVE_NAME
read -p "Block device to format >" DEST_DRIVE

## Generate password file
openssl genrsa -out "${DRIVE_NAME}.key" 4096
chmod 400 "${DRIVE_NAME}.key"

## CREATE SECURE DRIVE
# Format drive with LUKS
sudo cryptsetup --key-file "${DRIVE_NAME}.key" --hash sha512 luksFormat "${DEST_DRIVE}"

# Open LUKS volume
sudo cryptsetup --key-file "${DRIVE_NAME}.key" luksOpen "${DEST_DRIVE}" secure_data

# Format with xfs
sudo mkfs.xfs /dev/mapper/secure_data
sleep 3

# Close LUKS volume
sudo cryptsetup luksClose secure_data

# Encrypt key file
openssl enc -aes-256-cbc -pbkdf2 -salt -in "${DRIVE_NAME}.key" -out "${DRIVE_NAME}.key.enc"
rm -rf "${DRIVE_NAME}.key"
