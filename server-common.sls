include:
  - mercurial

mercurial-user:
  user.present:
    - name: hg
    - gid_from_name: true
    - home: /var/lib/hg
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
    - group: hg
    - mode: 3775
    - require:
      - user: mercurial-user