#!/bin/bash
## gpfsrest build script
## Makes use of "restit"
## https://github.com/oli4vr/restit
## by Olivier Van Rompuy 2023
echo "gpfsrest package builder script"
echo "by Olivier Van Rompuy 2023    Westpole"
echo "###################"
echo "git clone https://github.com/oli4vr/restit.git" 
git clone https://github.com/oli4vr/restit.git
if ! test -d restit
then
 echo "Error : restit dir not found, git clone failed" 
fi
cp main.csv restit/
cp gpfs.sh restit/
ps -ef | grep -v grep | grep -i restit | awk '{print $2}' | xargs -n1 kill -9 >/dev/null 2>&1
cd restit
make
make bundle
make clean
mv restit.*.sh ..
cd ..
rm -rf restit
chmod a+rx restit.*.sh
echo "###################"
echo "Installer Package :" $(ls -ltr restit.*.sh | tail)
echo "Distribute and install on GPFS nodes"
echo "Install with : ./"$(ls -tr restit.*.sh | tail)
echo "Uninstall    : ./"$(ls -tr restit.*.sh | tail)" -u"
echo "Access via   : http://hostname:40480"
