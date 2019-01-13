mercurial:
  {% if grains['os'] == "CentOS" and grains['cpuarch'] == "x86_64" %}
  pkgrepo.managed:
    - baseurl: https://www.mercurial-scm.org/release/centos$releasever
    - gpgcheck: 0
    - require_in:
      - pkg: mercurial
  pkg.installed:
    - require:
      - pkgrepo: mercurial
  {% else %}
  pkg.installed:
    - name: python-pip
    - unless: which pip
  pip.installed:
    - name: mercurial
    - require:
      - pkg: python-pip
  {% endif %}
