#!/bin/bash
(
/usr/lpp/mmfs/bin/mmlsfs all | grep 'File system attributes' | grep -v '.*\:.*\:.*' | tr -d \: | awk '{print $(NF)}' | sed -e 's/\/dev\///' | while read dev; do /usr/lpp/mmfs/bin/mmlsfileset $dev -Y -i -L | grep -vw HEADER ; done | awk -F\: '{if ($(33)>0) {printf("%02d %s\n",(100*$(15)/$(33)),$8);}}' | sort -r -n | head -n1 | awk '{printf("%d HIGHEST_FILESET_USED\n%s HIGHEST_FILESET_NAME\n",$1,$2);}'
) </dev/null 2>/dev/null
