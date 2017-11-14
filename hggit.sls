mercurial-hggit-extension:
  pkg.installed:
    - name: python-pip
    - unless: which pip
  pip.installed:
    - name: hg-git
    - require:
      - pkg: python-pip
  file.managed:
    - name: /etc/mercurial/hgrc.d/hggit.rc
    - contents: |
        [extensions]
        hggit =
    - makedirs: true
    - require:
      - pip: hg-git
