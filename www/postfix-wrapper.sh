#!/usr/bin/env bash
# postfix-wrapper.sh, version 0.1.0 
#
# You cannot start postfix in some foreground mode and 
# it's more or less important that docker doesn't kill 
# postfix and its chilren if you stop the container.
#
# Use this script with supervisord and it will take 
# care about starting and stopping postfix correctly.
#
# supervisord config snippet for postfix-wrapper:
# 
# [program:postfix]
# process_name = postfix
# command = /path/to/postfix-wrapper.sh
# startsecs = 0
# autorestart = false
# 
# Source - https://www.snip2code.com/Snippet/309436/postfix-wrapper-sh-for-supervisord-in-do

trap "postfix stop" SIGINT
trap "postfix stop" SIGTERM
trap "postfix reload" SIGHUP

# start postfix
/usr/sbin/postfix -c /etc/postfix start

# lets give postfix some time to start
sleep 3

# wait until postfix is dead (triggered by trap)
while kill -0 "`cat /var/spool/postfix/pid/master.pid`"; do
  sleep 5
done