#!/bin/bash
TMPF=/tmp/fsetcheck.${RANDOM}.$(date +%Y%m%d%H%M)
THR=95
TGT=94
MAXN=3

LOGDIR=${HOME}/.restit
LOGFILE=${LOGDIR}/inodechg.$(date +%Y%m%d).log
mkdir -p ${LOGDIR} 2>/dev/null
touch ${LOGFILE}

find ${LOGDIR} -name 'inodechg.*.log' -mtime +7 -exec rm -rf {} \;

/usr/lpp/mmfs/bin/mmlsfs all | grep 'File system attributes' | grep -v '.*\:.*\:.*' | tr -d \: | awk '{print $(NF)}' | sed -e 's/\/dev\///' | while read FSYS
do
 /usr/lpp/mmfs/bin/mmlsfileset $FSYS -i -Y >${TMPF}

 NRfsetnm=$(cat ${TMPF} | head -n1 | awk -F\: '{for(n=1;n<=NF;n++){if ($(n)=="filesetName") {print n;}}}')
 NRinodes=$(cat ${TMPF} | head -n1 | awk -F\: '{for(n=1;n<=NF;n++){if ($(n)=="inodes") {print n;}}}')
 NRinomax=$(cat ${TMPF} | head -n1 | awk -F\: '{for(n=1;n<=NF;n++){if ($(n)=="maxInodes") {print n;}}}')

 # Increase up to MAXN times per 24h
 cat ${TMPF} | grep -v 'HEADER' | cut -d\: -f ${NRfsetnm},${NRinodes},${NRinomax} | awk -F\: '{pct=$(2)*100/($(3)+1); if (pct>'${THR}') {itgt=$(2)*100/'$TGT';printf("%d %s %d %d %d\n",pct,$1,$2,$3,itgt);}}' | sort -n -r -k 1 | while read ipct fset icur imax itgt
 do
  NRE=$(cat ${LOGFILE} | awk '{if ($3=="'$fset'") {print $0}}'| wc -l | xargs echo)
  if ((NRE<MAXN))
  then
   echo /usr/lpp/mmfs/bin/mmchfileset $FSYS $fset --inode-limit $itgt >> $LOGFILE
   /usr/lpp/mmfs/bin/mmchfileset $FSYS $fset --inode-limit $itgt 
  fi
 done >/dev/null 2>&1

 # Report
 /usr/lpp/mmfs/bin/mmlsfileset $FSYS -i -Y >${TMPF}
 cat ${TMPF} | grep -v 'HEADER' | cut -d\: -f ${NRfsetnm},${NRinodes},${NRinomax} | awk -F\: '{pct=$(2)*100/($(3)+1);printf("%d %s %d %d\n",pct,$1,$2,$3);}' | sort -n -r -k 1 | head -n1 | while read ipct fset icur imax
 do
  echo $ipct HIGHEST_FILESET_USED
  echo $fset HIGHEST_FILESET_NAME
 done

 rm ${TMPF}
done
