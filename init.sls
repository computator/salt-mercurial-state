mercurial:
  pkgrepo.managed:
    {% if grains['os'] == "Ubuntu" %}
    - ppa: mercurial-ppa/releases
    {% elif grains['os'] == "CentOS" %}
    - baseurl: https://www.mercurial-scm.org/release/centos$releasever
    - gpgcheck: 0
    {% endif %}
    - unless: 'pip --disable-pip-version-check show hg-git | grep -qF "Installer: pip"'
    - require_in:
      - pkg: mercurial
  pkg.installed:
    - unless: 'pip --disable-pip-version-check show hg-git | grep -qF "Installer: pip"'
