#!/bin/bash

/usr/bin/apt update && \ 
/usr/bin/ssh-keygen -A && \ 
/usr/bin/apt install ssh -y && \
/usr/bin/systemctl enable --now ssh && \
/usr/bin/apt -y install cloud-guest-utils gdisk  >> /tmp/init.log && \
/usr/bin/growpart /dev/vda 1 && \
/usr/sbin/resize2fs /dev/vda1
/usr/bin/apt install -y apt-transport-https ca-certificates curl gnupg lsb-release  >> /tmp/init.log && \
/usr/bin/mkdir -p /etc/apt/keyrings && \
/usr/bin/curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
/usr/bin/echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
              $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
/usr/bin/apt update && \
/usr/bin/apt install containerd.io  >> /tmp/init.log && \
/usr/bin/echo overlay >> /etc/modules-load.d/k8s.conf && \
/usr/bin/echo br_netfilter >> /etc/modules-load.d/k8s.conf && \
/usr/sbin/modprobe overlay >> /tmp/init.log && \
/usr/sbin/modprobe br_netfilter >> /tmp/init.log && \
/usr/bin/echo net.bridge.bridge-nf-call-iptables  = 1 >> /etc/sysctl.d/k8s.conf && \
/usr/bin/echo net.bridge.bridge-nf-call-ip6tables = 1 >> /etc/sysctl.d/k8s.conf && \
/usr/bin/echo net.ipv4.ip_forward                 = 1 >> /etc/sysctl.d/k8s.conf && \
/usr/sbin/sysctl --system >> /tmp/init.log && \
/usr/bin/sed -i 's/cri//' /etc/containerd/config.toml && \
/usr/bin/systemctl restart containerd && \
/usr/bin/systemctl enable --now containerd && \
/usr/sbin/swapoff -a && \
/usr/bin/sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab && \
/usr/bin/apt update && \
/usr/bin/apt install -y apt-transport-https ca-certificates curl  >> /tmp/init.log && \
/usr/bin/curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
/usr/bin/echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
/usr/bin/apt update && \
/usr/bin/apt install -y kubelet kubeadm kubectl  >> /tmp/init.log && \
/usr/bin/apt-mark hold kubelet kubeadm kubectl  >> /tmp/init.log && \
/usr/bin/sleep 150 && \
/usr/bin/echo "I'm now awake and movin on!" >> /tmp/init.log && \ 
CERT_HASH=`/usr/bin/curl http://192.168.122.20:8000/init.log 2>&1 | grep -A3 "worker nodes" | grep discovery-token | awk {'print $2'}` && \
JOIN_TOKEN=`/usr/bin/curl http://192.168.122.20:8000/init.log 2>&1 | grep -A2 "worker nodes" | grep token | awk {'print $5'}` && \
/usr/bin/kubeadm join 192.168.122.10:6443 --token $JOIN_TOKEN --discovery-token-ca-cert-hash $CERT_HASH >> /tmp/init.log 

exit 0