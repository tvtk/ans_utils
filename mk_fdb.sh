#!/bin/bash
#

HALG="md5"
HCMD="${HALG}sum"
OUTF="fdb.csv"

START_TIME=$(date +%s)

if [ -f "${OUTF}" ]
then
   echo "ERROR: \"${OUTF}\" already exists!"
   echo "   Delete the old version first and then run this script again."
   exit 1
fi

echo "# created: $(date --date=@${START_TIME} +%Y%m%dT%H%M%S%z)" | tee "${OUTF}"
echo "# columns: <hash-algorithm>;<hash-value>;<file-name>" | tee -a "${OUTF}"
for file in *
do
   if [ -d "${file}" ]
   then
      # ignore/skip subdirs
      continue
   fi
   if [ "${file}" = "${OUTF}" ]
   then
      # do not generate inventory record for FDB
      continue
   fi
   HVAL=$(${HCMD} -b ${file} | awk '{print $1}')
   echo "\"${HALG}\";\"${HVAL}\";\"${file}\"" | tee -a "${OUTF}"
done
chmod -w "${OUTF}"
