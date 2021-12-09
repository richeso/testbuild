#!/bin/bash

E_BADARGS=12
E_BAD_RETURN_CODE=20
rc=0

startime=`date +%s`

findfile() {

	echo "input: " $input

	cd $input
	for file in *.$filetype
	do
 # do something on "$file"
 		echo "jar file found: $file" 
 ##modfile=${file//[-.]/|}
 		foundfile=$file
 		modfile=$(echo "$file" | sed -r 's/[-.]+/|/g')
 		echo "modfile: " $modfile
 		read appname major minor patch build type <<< $(echo $modfile | awk -F'|' '{print $1,$2,$3,$4,$5,$6}')
 		##echo $modfile | awk -F'|' '{print $1,$2,$3,$4,$5,$6}' | while read appname major minor patch build type
	 	##do
 		##done
 		break
	done
}

checkrc(){
   #echo "------------------------------"
   #echo "$1 return code = " $rc
   #echo "------------------------------"
   #echo " "
   if [ -z "$rc" ]; then
    let rc=0
   fi

   if [ $rc -gt 0 ]; then
      dt=$(date '+%d/%m/%Y %H:%M:%S');
      msgbody="-----> FAILED !! -- $STEP with return Code: $rc at time: $dt"
      echo $msgbody
      #emailcmd "$msgbody" "$0 $1 $2 - bad return code from checkrc(): $rc"
      exit $E_BAD_RETURN_CODE
    else
       dt=$(date '+%d/%m/%Y %H:%M:%S');
       echo "-----> SUCCESSFUL!! -- $STEP -- at time: $dt"
    fi
}

trim()
{
    echo $1 | sed 's/^[ \t]*//;s/[ \t]*$//' | sed -e 's/\r//g' | sed -e 's/\n//g'
}

get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     # While $SOURCE is a symlink, resolve it
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     echo "$DIR"
}

## jenkins pipeline invoation:
## def result = sh script: 'findfile || echo error', returnStdout: true
## def error = result.endsWith("error")

if [[ ! ( # any of the following are not true
        # 1st arg is input directory
        -n "$1"
        # 2nd arg is filetype
        && -n "$2"
        ) ]];
    then
        cat << EOF >&2
    Usage: $(basename "$0") " inputdir filetype "
EOF
     exit $E_BADARGS;
fi

SCRIPTPATH=$(get_script_dir)
curpath=$(pwd)
# Absolute path this script is in, e.g. /home/user/bin
echo "Script Loaded From: " $SCRIPTPATH
echo "Script is running under userid: " `whoami`
echo "current path is: " $curpath
echo "COMMAND: findfile.sh "$1 " " $2 " " $3 " " $4 " " $5
echo "Number of parameters is:  "$#
echo "Script parameters are: $0 $1 $2 $3 $4 $5"

input=$1
filetype=$2
foundfile=""
findfile
echo "foundfile="$foundfile
echo "appname: " $appname
echo "major:   " $major
echo "minor:   " $minor
echo "patch:   " $patch
echo "build:   " $build
echo "type:    " $type

curpath=$(pwd)
echo "current path: "$curpath
echo $foundfile
exit 0

