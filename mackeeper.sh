#!/bin/bash

# This program will check for an uninstall MacKeeper and JustCloud

CURUSER=`/usr/bin/who | grep console | cut -d ' ' -f1`

#################
### Variables ###
#################

# Items at the system level to be removed
declare -a systemItems=(
	/Applications/MacKeeper.app
	/Applications/JustCloud.app
	/Library/Preferences/.3FAD0F65-FC6E-4889-B975-B96CBF807B78
	/private/var/folders/mh/yprf0vxs3mx_n2lg3tjgqddm0000gn/T/MacKeeper*
	/private/tmp/MacKeeper*
	/Library/LaunchDaemons/com.mackeeper.Cerberus.plist
	/Library/LaunchDaemons/com.mackeeper.MacKeeper.MacKeeperPrivilegedHelper.plist
	/Users/$CURUSER/Library/Application\ Support/MacKeeper*
	/Users/$CURUSER/Library/LaunchAgents/com.zeobit.MacKeeper.Helper.plist
	/Users/$CURUSER/Library/LaunchAgents/com.jdibackup.JustCloud.autostart.plist
	/Users/$CURUSER/Library/LaunchAgents/com.jdibackup.JustCloud.notify.plist
	/Users/$CURUSER/Library/LaunchAgents/com.mackeeper.MacKeeper.Helper.plist
	/Users/$CURUSER/Library/Logs/JustCloud
	/Users/$CURUSER/Library/Logs/MacKeeper.log
	/Users/$CURUSER/Library/Logs/MacKeeper.log.signed
	/Users/$CURUSER/Library/Logs/SparkleUpdateLog.log
	/Users/$CURUSER/Library/Preferences/.3246584E-0CF8-4153-835D-C7D952862F9D
	/Users/$CURUSER/Library/Preferences/com.zeobit.MacKeeper.Helper.plist
	/Users/$CURUSER/Library/Preferences/com.zeobit.MacKeeper.plist
	/Users/$CURUSER/Library/Preferences/com.mackeeper.MacKeeper.Helper.plist
	/Users/$CURUSER/Library/Preferences/com.mackeeper.MacKeeper.plist
	/Users/$CURUSER/Library/Saved\ Application\ State/com.zeobit.MacKeeper.savedState
	/Users/$CURUSER/Downloads/MacKeeper*
	/Users/$CURUSER/Documents/MacKeeper*
)

#################
### Functions ###
#################
function deleteItems()
{
	for item in "${systemItems[@]}"
		do
			if [[ ! -z "${2}" ]]
				then
					item=("${2}""${item}")
			fi

			if [ -e "${item}" ]
				then
					echo "Removing $item" | logger -t MacKeeperKiller
					rm -rf "${item}"
			fi
			var=0
		done
		exit 0
}

function unloadMacKeeper()
{
	launchctl unload /Library/LaunchDaemons/com.mackeeper.Cerberus.plist 
	sleep 1 
	launchctl unload /Library/LaunchDaemons/com.mackeeper.MacKeeper.MacKeeperPrivilegedHelper.plist 
	sleep 1
	sudo -u $CURUSER launchctl unload ~/Library/LaunchAgents/com.mackeeper.MacKeeper.Helper.plist 
	sleep 1
}

####################
### Main Program ###
####################
	for item in "${systemItems[@]}"
	do
	if [[ ! -z "${2}" ]]
		then
			item=("${2}""${item}")
	fi
	if [ -e $item ]; then
		unloadMacKeeper
		deleteItems
	else 
		var=1
		echo MacKeeper not found | logger -t MacKeeperKiller
		exit 0
	fi

	done