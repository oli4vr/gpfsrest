#!/bin/bash
## gpfsrest build script
## Makes use of "restit"
## https://github.com/oli4vr/restit
## by Olivier Van Rompuy 2023
echo "gpfsrest package builder script"
echo "by Olivier Van Rompuy 2023    Westpole"
echo "###################"
export SUBNAME=$(cat main.csv | cut -d ';' -f 2 | xargs echo | tr ' ' '-')
if ! test -d restit
then
 echo "git clone https://github.com/oli4vr/restit.git" 
 git clone https://github.com/oli4vr/restit.git
 if ! test -d restit
 then
  echo "Error : git clone failed" 
 fi
else
 echo "Subdir restit found"
fi
cp main.csv restit/
cp mmhealth.sh restit/
cp filesets.sh restit/
ps -ef | grep -v grep | grep -i restit | awk '{print $2}' | xargs -n1 kill -9 >/dev/null 2>&1
cd restit
make
make bundle
make clean
mv restit.*.sh ..
cd ..
chmod a+rx restit.*.sh
if test -x /usr/bin/rpmbuild
then
 rm -rf ~/rpmbuild 2>/dev/null
 cp restit.*.sh gpfsrest.sh
 chmod u+x gpfsrest.sh
 cat gpfs.restit.spec.templ | sed -e 's/__RELEASE__/'$(date "+%Y %j" | awk '{printf("%02d%03d\n",$(1)-2024,$2);}')'/' | sed -e 's/__SUBNAME__/'${SUBNAME}'/' >gpfs.restit.spec
 echo rpmbuild --define \"_sourcedir $(pwd)\" -bb gpfs.restit.spec
 rpmbuild --define "_sourcedir $(pwd)" -bb gpfs.restit.spec >/dev/null 2>&1
 mv $(find ~/rpmbuild/RPMS -name '*.rpm'  | head -n1) .
 rm -rf ~/rpmbuild 2>/dev/null
 rm gpfsrest.sh
 rm gpfs.restit.spec
fi
RPMF=$(ls *.rpm 2>/dev/null | head -n1)
echo "###################"
echo "Installer Package :" $(ls -tr restit.*.sh | tail)
echo "Distribute and install on GPFS nodes"
echo "Install with : ./"$(ls -tr restit.*.sh | tail)
echo "Uninstall    : ./"$(ls -tr restit.*.sh | tail)" -u"
if [ "$RPMF" != "" ]
then
 echo "RPM package  : ${RPMF}"
fi
echo "Access via   : http://hostname:40480"

