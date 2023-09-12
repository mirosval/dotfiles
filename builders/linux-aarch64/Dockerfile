FROM nixos/nix

RUN nix-channel --update

RUN nix-env -f '<nixpkgs>' -iA \
  gnused \
  openssh \
  && nix-store --gc

RUN mkdir -p /etc/ssh \
 && mkdir -p /var/empty \
 && mkdir -p /run \
 && mkdir -p /var/log && touch /var/log/lastlog \
 && echo "sshd:x:498:65534::/var/empty:/run/current-system/sw/bin/nologin" >> /etc/passwd \
 && cp /root/.nix-profile/etc/ssh/sshd_config /etc/ssh \
 && sed -i 's/root:!:/root:*:/' /etc/shadow \
 && sed -i '/^PermitRootLogin/d' /etc/ssh/sshd_config \
 && echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
 && echo "export NIX_PATH=$NIX_PATH" >> /etc/bashrc \
 && echo "export NIX_SSL_CERT_FILE=$NIX_SSL_CERT_FILE" >> /etc/bashrc \
 && echo "export PATH=$PATH" >> /etc/bashrc \
 && echo "source /etc/bashrc" >> /etc/profile

COPY ./keys/id_ed25519 /root/.ssh/id_rsa
COPY ./keys/id_ed25519.pub /root/.ssh/authorized_keys
COPY ./keys/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key

COPY entrypoint.sh /

USER root

CMD ["/entrypoint.sh"]
