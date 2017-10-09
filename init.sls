mercurial:
  pkgrepo.managed:
    {% if grains['os'] == "Ubuntu" %}
    - ppa: mercurial-ppa/releases
    {% elif grains['os'] == "CentOS" %}
    - baseurl: https://www.mercurial-scm.org/release/centos$releasever
    - gpgcheck: 0
    {% endif %}
    - require_in:
      - pkg: mercurial
  pkg.installed: []
