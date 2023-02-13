#!/bin/bash

/usr/bin/apt update && /usr/bin/ssh-keygen -A && \
/usr/bin/systemctl restart ssh && \
/usr/bin/apt install ssh -y && \
/usr/bin/apt install haproxy -y && \
/bin/cp /root/haproxy.cfg /etc/haproxy/haproxy.cfg && \
/usr/bin/systemctl enable --now ssh && \
/usr/bin/systemctl enable --now haproxy && \
/usr/bin/systemctl restart haproxy

exit 0
