#!/bin/sh
[ "$1" = "hg" ] || exit 0

# The permissions file has one line per user, and each line has three fields:
# 
# user:  The username. This is just for reference purposes and is not actually
#        used. If the username is a single '*', then the repository list on
#        this line applies to all users in the lines below the current line,
#        and the key field is ignored if it exists.
# 
# repos: A space separated list of repositories. You can use shell globbing in
#        repository names to match more than one at once.
# 
# key:   The SSH public key for this user. If the user is '*', then this field
#        is ignored if it is present.
# 
# Each line is a list of fields separated by colons in the format:
# 
#        user:repos:key
# 
# Blank lines and lines starting with a '#' are ignored.
# 

perms_file="/var/lib/hg/permissions"

[ -r "$perms_file" ] || exit 0

trim () { for i in "$@"; do echo -n " $i"; done | grep -o '[^[:space:]].*' | grep -o '.*[^[:space:]]'; }

# die gracefully when we are killed with SIGPIPE once the key is found
trap "exit 0" PIPE

global_perms=""
while IFS=: read user perms key; do
	user=$(trim "$user")
	[ -n "$user" ] || continue
	[ "$(printf '%c' "$user")" != "#" ] || continue
	if [ "$user" = "*" ]; then
		if [ -z "$global_perms" ]; then
			global_perms="$(trim "$perms")"
		else
			global_perms="$global_perms $(trim "$perms")"
		fi
	else
		perms="$(trim "$perms")"
		if [ -n "$global_perms" ]; then
			perms="$global_perms $perms"
		fi
		printf 'command="cd /srv/hg && hg-ssh %b" %s -- %s\n' "$perms" "$(trim "$key")" "$user"
	fi
done < "$perms_file"
