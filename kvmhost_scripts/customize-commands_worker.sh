#!/bin/bash

/usr/bin/apt update && /usr/bin/ssh-keygen -A && /usr/bin/systemctl restart sshd && /usr/bin/apt install ssh -y

exit 0
