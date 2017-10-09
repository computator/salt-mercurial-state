mercurial-hggit-extension:
  pkg.installed:
    - name: python-pip
    - unless: which pip
  pip.installed:
    - name: hg-git
    - require:
      - pkg: python-pip
