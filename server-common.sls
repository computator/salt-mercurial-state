mercurial-user:
  user.present:
    - name: hg
    - gid_from_name: true
    - remove_groups: false
    - home: /var/lib/hg
    - enforce_password: false
    - system: true

mercurial-srv-root:
  file.directory:
    - name: /srv/hg
    - user: hg
    - group: hg
    - mode: 3777