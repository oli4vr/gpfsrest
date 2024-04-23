#!/bin/bash
FSETLOG=~/.restit/inodechg.$(date +%Y%m%d).log
if test -r ${fsetlog}
then
 cat $FSETLOG | grep -w mmchfileset | wc -l | xargs echo | awk '{print $1,"FILESET_AUTOEXTENDS"}'
else
 echo 0 FILESET_AUTOEXTENDS
fi
