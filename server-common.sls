include:
  - mercurial

mercurial-user:
  user.present:
    - name: hg
    {% if grains['saltversioninfo'][0] > 2018 %}
    - usergroup: true
    {% endif %}
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
    - mode: 3777
    - require:
      - user: mercurial-user