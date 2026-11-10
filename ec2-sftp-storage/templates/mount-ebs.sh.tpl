#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/sftp-ebs-setup.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting EBS volume configuration..."

VOLUME_ID="${volume_id}"
VOLUME_SERIAL="${replace(volume_id, "-", "")}"

DEVICE=""

# Wait for the attached EBS volume
for attempt in $(seq 1 120); do

    DEVICE=$(lsblk -dn -o NAME,SERIAL,TYPE | \
      awk -v id="$VOLUME_SERIAL" \
      '$2 == id && $3 == "disk" {print "/dev/"$1; exit}')

    if [ -n "$DEVICE" ]; then
        break
    fi

    echo "Waiting for EBS volume: $attempt"
    sleep 5

done

if [ -z "$DEVICE" ]; then
    echo "ERROR: EBS volume not found: $VOLUME_ID"
    exit 1
fi

echo "Detected EBS device: $DEVICE"

# Check existing filesystem
FILESYSTEM=$(blkid -s TYPE -o value "$DEVICE" || true)

if [ -z "$FILESYSTEM" ]; then

    echo "Creating ext4 filesystem..."

    mkfs.ext4 "$DEVICE"

elif [ "$FILESYSTEM" != "ext4" ]; then

    echo "ERROR: Unexpected filesystem: $FILESYSTEM"
    exit 1

else

    echo "Existing ext4 filesystem detected."

fi

# Retrieve filesystem UUID
UUID=$(blkid -s UUID -o value "$DEVICE")

if [ -z "$UUID" ]; then
    echo "ERROR: Filesystem UUID not found."
    exit 1
fi

echo "Filesystem UUID: $UUID"

# Create mount point
mkdir -p /sftp-data

# Configure persistent mount
if ! grep -q "UUID=$UUID" /etc/fstab; then

    echo "UUID=$UUID /sftp-data ext4 defaults,nofail 0 2" >> /etc/fstab

fi

# Mount volume
mount /sftp-data

# Verify mount
if mountpoint -q /sftp-data; then
    echo "EBS volume successfully mounted."
else
    echo "ERROR: Mount failed."
    exit 1
fi

# Initial directory permissions
chown root:root /sftp-data
chmod 755 /sftp-data

echo "EBS configuration completed."

df -h /sftp-data