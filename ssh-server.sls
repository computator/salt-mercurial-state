include:
  - mercurial
  - mercurial.server-common

mercurial-sshd:
  pkg.installed:
    - name: openssh-server
  service.running:
    - name: ssh
    - enable: true

mercurial-ssh-config:
  file.blockreplace:
    - name: /etc/ssh/sshd_config
    - marker_start: '# start mercurial-ssh-server managed section'
    - marker_end: '# end mercurial-ssh-server managed section'
    - content: |
        Match User hg
          AllowAgentForwarding no
          AllowTcpForwarding no
          AllowStreamLocalForwarding no
          PermitTTY no
          PermitTunnel no
          X11Forwarding no

          PubkeyAuthentication yes
          AuthenticationMethods publickey

          AuthorizedKeysFile none

          AuthorizedKeysCommand /usr/local/lib/hg/authorized_keys_handler.sh
          AuthorizedKeysCommandUser hg
        Match All
    - append_if_not_found: true
    - require:
      - pkg: mercurial-sshd
    - watch_in:
      - service: mercurial-sshd

mercurial-ssh-auth-script:
  file.managed:
    - name: /usr/local/lib/hg/authorized_keys_handler.sh
    - source: salt://mercurial/auth_handler.sh
    - mode: 755
    - makedirs: true

mercurial-ssh-auth-template:
  file.managed:
    - name: /etc/mercurial/server-perms.conf
    - contents: |
        # Format:
        #     <user>:<repos>:<key>
        # See /usr/local/lib/hg/authorized_keys_handler.sh for more information.
    - mode: 644
    - replace: false
