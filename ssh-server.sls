include:
  - mercurial.server-common

mercurial-sshd:
  pkg.installed:
    - name: openssh-server
  service.running:
    - name: ssh

mercurial-ssh-config:
  file.blockreplace:
    - name: /etc/ssh/sshd_config
    - marker_start: '# start mercurial-ssh-server managed section'
    - marker_end: '# end mercurial-ssh-server managed section'
    - content: |
        Port 2222
        Match LocalPort 2222
          AllowUsers hg

          AllowAgentForwarding no
          AllowTcpForwarding no
          PermitTTY no
          PermitTunnel no
          X11Forwarding no

          KbdInteractiveAuthentication no
          PasswordAuthentication no
          PubkeyAuthentication yes

          AuthorizedKeysCommand /usr/local/lib/hg/authorized_keys_handler.sh
          AuthorizedKeysCommandUser hg
          AuthorizedKeysFile /dev/null
        Match All
    - append_if_not_found: true
    - require:
      - pkg: openssh-server
    - watch_in:
      - service: mercurial-sshd

mercurial-ssh-auth-script:
  file.managed:
    - name: /usr/local/lib/hg/authorized_keys_handler.sh
    - source: salt://mercurial/auth_handler.sh
    - mode: 755
    - makedirs: true