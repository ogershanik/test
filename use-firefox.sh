#!/bin/bash
ver=$1

ffdir='/opt/firefox'
verdir="/opt/firefox/$ver"
sysff='/usr/bin/firefox'

function isok() {
	err=$?
	if [ $err -ne 0 ]; then
		echo $1
		exit $err
	fi
}

if [ ! -d $ffdir ]; then
        echo "creating $ffdir"
        sudo mkdir $ffdir
	isok "Cannot create $ffdir"
        uid=`id -u`
        echo $uid
        sudo chown $uid $ffdir
	isok "Cannot chown $ffdir"
fi
#exit
#check if it's already there
if [ -e $sysff ]; then
        if ! [ -L $sysff ]; then
        echo "$sysff exists and is a regular file. Exiting"
        exit 1
        fi
fi



#are we ready and have all needed libs

sudo dpkg -l libgtk-3-0 | grep -q ii
        if [ $? -eq 0 ]; then
                echo "Ready to install Firefox $ver"
        else
                echo "Need to install required libs!"
                sudo apt-get -y update
                isok "Cannot update repository listings"
                sudo apt-get install -y libgtk-3-0
                isok "Cannot install libgtk for Firefox needs"
        fi

if [ -L $sysff ]; then

        ls -l $sysff| grep -q $ver
        if [ $? -eq 0 ]; then
                echo "Firefox is already active and is version $ver"
                exit 0
        else
                echo "Firefox is active but is wrong version"
        fi
fi


if [ ! -d $verdir ]; then
                sudo mkdir $verdir
                isok "Can not make directory $verdir"
                echo "Downloading from mozilla.org version $ver"
                sudo wget 'https://ftp.mozilla.org/pub/firefox/releases/'$ver'/linux-x86_64/en-US/firefox-'$ver'.tar.bz2' -P $verdir
                isok "Download failed"
                sudo tar xjf "$verdir/firefox-${ver}.tar.bz2" -C $verdir
                echo "Cleaning up"
                sudo rm -f "$verdir/firefox-'$ver'.tar.bz2"
                else
                        if [ -f $verdir/firefox/firefox ]; then
                        echo "Firefox $ver is present in the system"
                        fi
fi
echo "Activating $ver "
sudo rm -f $sysff

if [ -f $verdir/firefox/firefox ]; then
        sudo ln -s $verdir/firefox/firefox $sysff
        isok "Cannot symlink firefox for activation!"
fi

echo "Firefox $ver is activated."
