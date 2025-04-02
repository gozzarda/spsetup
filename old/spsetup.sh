#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

cd /usr/share/spsetup

PS3='Select option: '
opts=("Perform first time setup" "Archive and reset team user" "Clear team archives" "Enable firewall" "Disable firewall" "Quit")
select opt in "${opts[@]}"
do
	case $opt in
		"${opts[0]}" )
			./setup.sh
			echo "SETUP COMPLETE"
			echo "You probably want to enable the firewall now."
			break;
			;;
		"${opts[1]}" )
			./wipe_team.sh
			./make_team.sh
			echo "TEAM RESET"
			break;
			;;
		"${opts[2]}" )
			./clear_archives.sh
			echo "ARCHIVES CLEARED"
			break;
			;;
		"${opts[3]}" )
			./enable_firewall.sh
			echo "FIREWALL ENABLED"
			break;
			;;
		"${opts[4]}" )
			./disable_firewall.sh
			echo "FIREWALL DISABLED"
			break;
			;;
		"${opts[5]}" )
			break
			;;
		* ) echo "Invalid selection";;
	esac
done
