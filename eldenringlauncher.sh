#!/bin/sh

# Workaround for Easy Anti-Cheat in Elden Ring.
# Disables active network interfaces, then runs the command from stdin,
# then re-enables network interfaces a few (default 5) seconds later

SYSLOG_IDENTIFIER=eldenringlauncher
NETWORK_RESTORE_DELAY=5

ifdown() {
	nmcli connection down $@
}

ifup() {
	nmcli connection up $@
}

ifactive() {
	nmcli --get-value UUID connection show --active | xargs
}

restoreif() {
	sleep $NETWORK_RESTORE_DELAY
	res=$(2>&1 ifup $@)
	if ! $?; then
		MESSAGES=""
		if [ -n "$res" ]; then
			MESSAGES=$(echo "$res" | awk '{print "MESSAGE=" $0}')
		fi
		logger --journald <<EOF
SYSLOG_IDENTIFIER=$SYSLOG_IDENTIFIER
PRIORITY=3
MESSAGE=Failed to bring interfaces online
$MESSAGES
EOF
		exit 1
	else
		logger --journald <<EOF
SYSLOG_IDENTIFIER=$SYSLOG_IDENTIFIER
PRIORITY=6
MESSAGE=Brought interface(s) back up
EOF
	fi
}

active_ifs=ifactive()

if [ -z "$active_ifs" ]; then
	logger --journald <<EOF
SYSLOG_IDENTIFIER=$SYSLOG_IDENTIFIER
PRIORITY=5
MESSAGE=No active interfaces found, taking no action
EOF
else
	logger --journald <<EOF
SYSLOG_IDENTIFIER=$SYSLOG_IDENTIFIER
PRIORITY=6
MESSAGE=Taking interface(s) offline for $NETWORK_RESTORE_DELAY seconds: $active_ifs
EOF
	res=$(2>&1 ifdown $active_ifs)
	if ! $?; then
		MESSAGES=""
		if [ -n "$res" ]; then
			MESSAGES=$(echo "$res" | awk '{print "MESSAGE=" $0}')
		fi
		logger --journald <<EOF
SYSLOG_IDENTIFIER=$SYSLOG_IDENTIFIER
PRIORITY=3
MESSAGE=Failed to take interface(s) offline
$MESSAGES
EOF
		exit 1
	else
		restoreif $active_ifs &
	fi
fi


exec "$@"
