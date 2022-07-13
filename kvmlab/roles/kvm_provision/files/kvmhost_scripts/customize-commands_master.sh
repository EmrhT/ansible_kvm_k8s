#!/bin/bash

/usr/bin/apt update && \
/usr/bin/ssh-keygen -A && \ 
/usr/bin/apt install ssh -y && \
/usr/bin/systemctl enable --now ssh && \
/usr/bin/apt -y install cloud-guest-utils gdisk && \
/usr/bin/growpart /dev/vda 1 && \
/usr/sbin/resize2fs /dev/vda1 && \
/usr/bin/apt install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
/usr/bin/mkdir -p /etc/apt/keyrings && \
/usr/bin/curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
/usr/bin/echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
              $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
/usr/bin/apt update && \
/usr/bin/apt install containerd.io && \
/usr/bin/echo overlay >> /etc/modules-load.d/k8s.conf && \
/usr/bin/echo br_netfilter >> /etc/modules-load.d/k8s.conf && \
/usr/sbin/modprobe overlay && \
/usr/sbin/modprobe br_netfilter && \
/usr/bin/echo net.bridge.bridge-nf-call-iptables  = 1 >> /etc/sysctl.d/k8s.conf && \
/usr/bin/echo net.bridge.bridge-nf-call-ip6tables = 1 >> /etc/sysctl.d/k8s.conf && \
/usr/bin/echo net.ipv4.ip_forward                 = 1 >> /etc/sysctl.d/k8s.conf && \
/usr/sbin/sysctl --system && \
/usr/bin/sed -i 's/cri//' /etc/containerd/config.toml && \
/usr/bin/systemctl restart containerd && \
/usr/bin/systemctl enable --now containerd && \
/usr/sbin/swapoff -a && \
/usr/bin/sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab && \
/usr/bin/apt update && \
/usr/bin/apt install -y apt-transport-https ca-certificates curl && \
/usr/bin/curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
/usr/bin/echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list && \
/usr/bin/apt update && \
/usr/bin/apt install -y kubelet kubeadm kubectl && \
/usr/bin/apt-mark hold kubelet kubeadm kubectl && \
/usr/bin/kubeadm init --apiserver-advertise-address=192.168.122.20 --apiserver-cert-extra-sans=192.168.122.20 \ 
--pod-network-cidr=10.244.0.0/16 --control-plane-endpoint=192.168.122.10 --node-name master && \
/usr/bin/kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')" 

exit 0
