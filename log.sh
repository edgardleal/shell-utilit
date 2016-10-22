#!/bin/bash

declare debug=1
declare logdir="${HOME}/logs/"
declare logfile="${logdir}log.txt"
declare logMaxSize="30"

function log_gen_id(){
  local sequenceFile="${logdir}.sequence"
  if [ ! -f "${sequenceFile}" ]; then
     echo "0" > ${sequenceFile}
  fi
  local val=$(cat ${sequenceFile})
  ((val++))

  echo "${val}" > ${sequenceFile}
  echo "${val}"
}

function checklog(){
  local count=0  
}


function log(){
  local text=""
  local _date=$(date "+%Y-%m-%d %H:%M")
  if [ $# -gt 0 ]; then
    text="$@"
  else
    while read data
    do 
      text="${text}\n${data}"
    done
  fi
  echo -e "[${_date}] - ${text}" >> ${logfile}
  if [ ${debug} ]; then 
    echo -e "[${_date}] - ${text}"
  fi
}
 
