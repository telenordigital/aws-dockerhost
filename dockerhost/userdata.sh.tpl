#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

cd /var/lib/cloud/instance/scripts

export AWS_DEFAULT_REGION=${aws_region}

# Prereqs
apt-get update &&  apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common


# Install SSM agent
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb -O /tmp/amazon-ssm-agent.deb
dpkg -i /tmp/amazon-ssm-agent.deb
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent

# Mount EBS volume
if [ ${mount_ebs} = "1" ]; then
    # Find the partition root is mounted on
    root_dev_part=`df / --output="source" | sed -n '1!p'`

    # Pick only the name of the partition
    root_part=`echo $root_dev_part | cut -d'/' -f3`

    # Find the device the partition belongs to
    root_dev=`lsblk -no pkname $root_dev_part`

    # Determine the other device apart from the root
    ebs_dev=`lsblk -no name | grep -v $root_part | grep -v $root_dev`

    # Mount ebs-volume
    isformatted=`blkid -o value -s TYPE /dev/$ebs_dev || :`
    if [[ -z $isformatted ]]; then
        #create fs
        mkfs -t ext4 /dev/$ebs_dev
    fi

    # Only mount if ext4
    isformatted=`blkid -o value -s TYPE /dev/$ebs_dev || :`
    if [ "$isformatted" == "ext4" ]; then
        # Create folder
        mkdir -p /mnt/ebs
        # Mount
        mount "/dev/$ebs_dev" /mnt/ebs
        # Update fstab
        echo "/dev/$ebs_dev /mnt/ebs ext4 defaults,nofail 0 2" >> /etc/fstab
    else
        exit 1
    fi
fi

# Download secrets
mkdir -p /mnt/secrets
aws s3 cp s3://${s3_secrets} /mnt/secrets --recursive
# Give read access to secrets
chmod -R 444 /mnt/secrets/* || :
# Add cron job to sync
echo "*/30 * * * * aws s3 cp s3://"${s3_secrets}" /mnt/secrets --recursive && chmod -R 444 /mnt/secrets/* || :" >> /etc/cron.d/secrets-sync
#(crontab -l ; echo "*/30 * * * * ")| sort -u | crontab -

# Enable docker to recover after a reboot
systemctl enable docker


# Add reboot timer
if [ ${host_reboot_frequency} -gt 0 ]; then
    cat > /etc/systemd/system/regreboot.service <<EOF
[Unit]
Description=Reboot regularly

[Service]
Type=oneshot
ExecStart=systemctl reboot
EOF
    cat > /etc/systemd/system/regreboot.timer <<EOF
[Unit]
Description= Regular reboot

[Timer]
OnCalendar=*-*-* 0/${host_reboot_frequency}:${frequency_offset}
RandomizedDelaySec=60

[Install]
WantedBy=timers.target
EOF
    systemctl enable --now regreboot.timer
fi

# Add a docker restart timer
if [ ${docker_restart_frequency} -gt 0 ]; then
    cat > /etc/systemd/system/dockerrestart.service <<EOF
[Unit]
Description=Restart docker
Requires=docker

[Service]
Type=oneshot
WorkingDirectory=/var/lib/cloud/instance/scripts
ExecStart=docker-compose restart
EOF
    cat > /etc/systemd/system/dockerrestart.timer <<EOF
[Unit]
Description= Regular docker reboot

[Timer]
OnCalendar=*-*-* 0/${docker_restart_frequency}:${frequency_offset}
RandomizedDelaySec=60

[Install]
WantedBy=timers.target
EOF
    systemctl enable --now dockerrestart.timer
fi


# Authenticate to ECR, the no-include-mail is required for newer version of docker
$(aws ecr get-login --no-include-email)

docker-compose up -d
