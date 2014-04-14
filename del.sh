#!/bin/bash



################################################################## 
#                                                                # 
#                                                                # 
#                                                                # 
#                                                                # 
#                                                                # 
# @author Edgard Leal                                            # 
#                                                                # 
##################################################################	

. /home/edgardleal/bin/log.sh


declare -r trash="$HOME/.trash"
declare -r -i maxsize=500


if [ ! -d "$HOME/.trash" ]; then 
  mkdir "$HOME/.trash"
fi

clear(){
  files="`find -mtime +30`"
  for f in files
  do
    echo "$f"
  done
}

function newname
{
  local sequencename="$trash/.sequence"
  if [ ! -f $sequencename ]; then 
    echo "0" > $sequencename
  fi  
  local value=$(cat "${sequencename}")
  ((value++))
  
  echo "$value" > $sequencename
  echo $value
}

function movedir
{
  if [ ! -d $2 ]; then 
    mkdir $2
  fi 

  for var in "$1/*"
  do 
    if [ -f "$var" ]; then 
      mv "$1/$var" $2
    else
      movedir $1 $var
    fi 
  done
}

function deletedir
{
  local sequence="`newname`"
  local newlocalname="$trash/${sequence}"
  echo "${sequence}|$1"i >> "$trash/.catalog"
  mkdir $newlocalname
  

  rm "$1"
}


function deletefile
{
  local filename="$1"
  local sequence="`newname`"
  local newlocalname="$trash/${sequence}"
  echo "${sequence}|$1" >> "$trash/.catalog"
  mv "$1" "${newlocalname}"
  log "O usuario [$USER] removeu o arquivo [$1]"
}


function delete
{
  if [ -d "$1" ]; then 
    mv "$1" $trash
  else
	if [ -f "$1" ]; then
	  deletefile "$1"
    	else
 	  echo "File or directory not exists: [$1]"
 	  exit 1
	fi
  fi
}

if [ "$1" == "-ls" ]; then
  ls -ag $trash
  exit 0
else
	if [ "$1" ==  "-c" ]; then
	    	clear
		exit 0
	else
		if [ "$1" == "-s" ]; then
			echo -e "Current size of trash folder: `du -m $trash | tail -1`"
			exit 0
		else
			if [ "$1" == "-h" ]; then 
				echo -e "Usage [del [files] or [options]]"
				echo -e "-ls -> List files in trash folder \n-c -> Remove files deletes after 30 days\n-s -> Show current size of trash folder"
				exit 0
			fi
		fi
	fi
fi

(
for item in $@
do
  filename="$item"
  isabsolute=$(echo "$filename" | sed "s/\/.*/1/g") 
  if [ "$isabsolute" != "1" ]; then 
    filename="`pwd`/$filename"
  fi  
  delete "$filename"
done
)
size="`du -m $trash | tail -1`"
size="`echo $size | sed 's/\([0-9]\+\).*/\1/g'`"
echo "Current size of Trash folder: $size Mb"
exit 1

