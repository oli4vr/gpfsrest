#!/bin/bash
(
/usr/lpp/mmfs/bin/mmhealth cluster show -Y | egrep -v 'HEADER|^$' | awk -F \: 'BEGIN{fail=0;degr=0}{fail+=$10;degr+=$11;}END{printf("%d FAILED\n%d DEGRADED\n",fail,degr);}'
/usr/lpp/mmfs/bin/mmhealth cluster show -Y | egrep -v 'HEADER|^$' | awk -F\: '{printf("%d %s_FAILED\n%d %s_DEGRADED\n",$10,$7,$11,$7);}' 
/usr/lpp/mmfs/bin/mmlsfs all | grep 'File system attributes' | grep -v '.*\:.*\:.*' | tr -d \: | awk '{print $(NF)}' | sed -e 's/\/dev\///' | while read dev; do /usr/lpp/mmfs/bin/mmlsfileset $dev -Y -i -L | grep -vw HEADER ; done | awk -F\: '{if ($(33)>0) {printf("%02d %s\n",(100*$(15)/$(33)),$8);}}' | sort -r -n | head -n1 | awk '{printf("%d HIGHEST_FSET\n",$1);}'
) </dev/null 2>/dev/null
