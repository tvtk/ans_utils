#!/bin/bash
#

HALG="md5"
INPF="fdb.csv"

START_TIME=$(date +%s)

get_halg () {
   # extract required field
   RETVAL=$(echo ${1} | awk -F ";" '{print $1}')
   # strip CSV string quoting
   if [[ $RETVAL =~ \"(.*)\" ]]
   then
      RETVAL=${BASH_REMATCH[1]}
   else
      RETVAL=""
   fi
   echo ${RETVAL}
}

get_hash () {
   # extract required field
   RETVAL=$(echo ${1} | awk -F ";" '{print $2}')
   # strip CSV string quoting
   if [[ $RETVAL =~ \"(.*)\" ]]
   then
      RETVAL=${BASH_REMATCH[1]}
   else
      RETVAL=""
   fi
   echo ${RETVAL}
}

get_fnam () {
   # extract required field
   RETVAL=$(echo ${1} | awk -F ";" '{print $3}')
   # strip CSV string quoting
   if [[ $RETVAL =~ \"(.*)\" ]]
   then
      RETVAL=${BASH_REMATCH[1]}
   else
      RETVAL=""
   fi
   echo ${RETVAL}
}

######

if [ ! -f "${INPF}" ]
then
   echo "ERROR: \"${INPF}\" does not exist!"
   echo "   Use \"mk_fdb.sh\" to create it."
   exit 1
fi

# check if dir contains all files registered in FDB
for line in $(cat "${INPF}" | grep -v "^#.*")
do
   # extract filename
   FNAM=$(get_fnam $line)
   if [ ! -n "${FNAM}" ]
   then
      echo "ERROR: skipping bad FDB record \"${line}\""
      continue
   fi
   ##echo "- dbg: Checking presence of \"${FNAM}\""
   if [ -f "${FNAM}" ]
   then
      # file is present -> verify hash
      HALG=$(get_halg $line)
      HASH=$(get_hash $line)
      if [ -n "${HALG}" -a -n "${HASH}" ]
      then
         ##echo "- dbg: Validating \"$HALG\" hash \"${HASH}\" of \"${FNAM}\""
         HCMD="${HALG}sum"
         HVAL=$(${HCMD} -b ${FNAM} | awk '{print $1}')
         if [ ! "${HASH}" = "${HVAL}" ]
         then
            echo "- Registered file hash chk failed: \"${FNAM}\""
         fi
      else
         echo "ERROR: skipping hash check for bad FDB record \"${line}\""
         continue
      fi
   else
      echo "- Registered file missing: \"${FNAM}\""
   fi
done

# check if all files within dir are registered in FDB
for file in *
do
   if [ -d "${file}" ]
   then
      # ignore/skip subdirs
      continue
   fi
   if [ "${file}" = "${INPF}" ]
   then
      # ignore/skip FDB
      continue
   fi
   FDB_REC=$( grep "${file}" "${INPF}")
   ##echo "- dbg: Checking registration of \"${file}\""
   ##echo "       FDB_MATCH=\"${FDB_REC}\""
   if [ ! -n "${FDB_REC}" ]
   then
            echo "- Unregistered file detacted: \"${file}\""
   fi
done
