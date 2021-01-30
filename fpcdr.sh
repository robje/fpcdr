#! /bin/sh

# this script automates F P C D R (Fast Power Cycle Device Recovery)
# using 2nd tasmotized plug accessed via HTTP

# second device to use
sec='192.168.107.138'

# When second device is configured with a password enter it below
# pass=secret

# where to find curl
CURL="/usr/bin/curl"
CURLOPT="-s" # no output from curl

auth=""
# shellcheck disable=SC2154
if [ -n "${pass}" ]; then
	auth="&user=admin&password=${pass}"
fi

# power commands
pon="${CURL} ${CURLOPT} http://${sec}/cm?cmnd=Power%20On${auth}"
poff="${CURL} ${CURLOPT} http://${sec}/cm?cmnd=Power%20Off${auth}"

# copied from https://tasmota.github.io/docs/Device-Recovery/ (dd 2021-01-30)

## Fast Power Cycle Device Recovery
#
# Implemented for situations where a device cannot be reset to
# firmware defaults by other means (no serial access, no
# button). It resets ALL Tasmota settings (equal to Reset 1)
# after 7 power cycles.
#
# SetOption65 must be set to 0 (default) in order for this
# feature to be enabled.
#
# Procedure
#
# 1.  Cut power from the device completely for 30 seconds
res=$(${poff})
echo "$(date +%X) $res"
sleep 30

# 2.  Power the device on and off six times with intervals lower than
#     10 seconds and ...
# shellcheck disable=SC2034
for i in 1 2 3 4 5 6
do
	res=$(${pon})
	echo "$(date +%X) $res"
	sleep 2
	res=$(${poff})
	echo "$(date +%X) $res"
	sleep 2
done

#     ... leave it on after seventh time
res=$(${pon})
echo "$(date +%X) $res"

# 3.  Fast power cycle device recovery should activate and the device should be reset to firmware defaults

# If you flashed a precompiled binary you can reconfigure the device using the web UI after the reset.
