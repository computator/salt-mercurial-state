mercurial-user:
  user.present:
    - name: hg
    - gid_from_name: true
    - remove_groups: false
    - home: /var/lib/hg
    - enforce_password: false
    - system: true

mercurial-trust-group:
  file.managed:
    - name: /var/lib/hg/.hgrc
    - contents: |
        [trusted]
        groups = hg
    - user: hg
    - group: hg
    - mode: 644
    - replace: false
    - require:
      - user: mercurial-user

mercurial-srv-root:
  file.directory:
    - name: /srv/hg
    - user: hg
    - group: hg
    - mode: 3777
    - require:
      - user: mercurial-user