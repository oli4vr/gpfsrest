#!/bin/bash
(
/usr/lpp/mmfs/bin/mmhealth cluster show -Y | egrep -v 'HEADER|^$' | awk -F \: 'BEGIN{fail=0;degr=0}{fail+=$10;degr+=$11;}END{printf("%d FAILED\n%d DEGRADED\n",fail,degr);}'
/usr/lpp/mmfs/bin/mmhealth cluster show -Y | egrep -v 'HEADER|^$' | awk -F\: '{printf("%d %s_FAILED\n%d %s_DEGRADED\n",$10,$7,$11,$7);}' 
) </dev/null 2>/dev/null
