{% set version = salt['pillar.get']("mercurial:lookup:version", '3.8.4') %}
mercurial:
  archive.extracted:
    - name: /tmp
    - source:
      - salt://mercurial/store/mercurial-{{version}}.tar.gz
      - https://www.mercurial-scm.org/release/mercurial-{{version}}.tar.gz
    - source_hash: sha1=a77ddd9640600c8901d0a870f525a660fa6251fa
    - archive_format: tar
    - if_missing: /tmp/mercurial-{{version}}
    - unless:
      - 'test -f /usr/local/bin/hg && [ "$(hg --version | head -n 1 | grep -o "version [0-9.]\+" | cut -d " " -f 2)" = "{{version}}" ]'
  pkg.installed:
    - name: mercurial-dependencies
    - pkgs:
      - gcc
      - make
      - python-dev
      - python-docutils
  cmd.run:
    - name: make install
    - cwd: /tmp/mercurial-{{version}}
    - require:
      - archive: mercurial
      - pkg: mercurial-dependencies
    - unless:
      - 'test -f /usr/local/bin/hg && [ "$(hg --version | head -n 1 | grep -o "version [0-9.]\+" | cut -d " " -f 2)" = "{{version}}" ]'
  file.copy:
    - name: /usr/local/bin/hg-ssh
    - source: /tmp/mercurial-{{version}}/contrib/hg-ssh
    - force: true
    - makedirs: true
    - mode: 755
    - require:
      - archive: mercurial
      - cmd: mercurial
    - onchanges:
      - archive: mercurial
      - cmd: mercurial
