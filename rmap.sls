rmap:
  file.managed:
    - name: /usr/local/bin/rmap
    - source: https://github.com/rlifshay/rmap/raw/master/rmap.sh
    - skip_verify: true
    - mode: 755
    - makedirs: true
    - show_changes: false