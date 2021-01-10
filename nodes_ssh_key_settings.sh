#! /usr/bin/env bash

ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa <<< n

mapfile  -t server_hosts < <(cat /etc/hosts | grep -o '\s.*' | sed -e 's/^[ \t]*//')
declare -a server_users=("vagrant")
key_val=$(cat /root/.ssh/id_rsa.pub)
echo $key_val
for host in "${server_hosts[@]}"; do
	echo $host
	sshpass -p vagrant ssh -o StrictHostKeyChecking=no root@$host "grep '$key_val' /root/.ssh/authorized_keys || echo '$key_val' >> /root/.ssh/authorized_keys"
	for user in "${server_users[@]}"; do
		sshpass -p vagrant ssh -o StrictHostKeyChecking=no $user@$host "grep '$key_val' /home/$user/.ssh/authorized_keys || echo '$key_val' >> /home/$user/.ssh/authorized_keys"
	done
done
