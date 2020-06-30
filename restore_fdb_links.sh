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

if [ $# -lt 1 ]
then
   echo "ERROR: mandatory argument missing"
   echo "   Usage: ./restore_fdb_links.sh <packages-search-base>"
   exit 1
else
   SRCBAS="${1}"
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
   # extract hash info from FDB record
   HALG=$(get_halg $line)
   HASH=$(get_hash $line)
   HCMD="${HALG}sum"
   if [ -f "${FNAM}" ]
   then
      # file is present -> verify hash
      if [ -n "${HALG}" -a -n "${HASH}" ]
      then
         ##echo "- dbg: Validating \"$HALG\" hash \"${HASH}\" of \"${FNAM}\""
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
      ##echo "- Registered file missing: \"${FNAM}\""
      if [ -n "${HALG}" -a -n "${HASH}" ]
      then
         # try to find package candidates
         PCLST=$(find "${SRCBAS}" -name "${FNAM}")
         RESTORED=0
         for package in ${PCLST}
         do
            # calculate hash of the package candidate
            HVAL=$(${HCMD} -b ${package} | awk '{print $1}')
            if [ "${HASH}" = "${HVAL}" ]
            then
               # match -> proper package found -> make the link
               ln -s "${package}" "${FNAM}"
               echo "- Restored file link: \"${FNAM}\" -> \"${package}\""
               RESTORED=1
               break
            fi
         done
         if [ ${RESTORED} -eq 0 ]
         then
            echo "- Missing file not found: \"${FNAM}\""
         fi
      else
         echo "ERROR: skipping hash check for bad FDB record \"${line}\""
         continue
      fi
   fi
done


