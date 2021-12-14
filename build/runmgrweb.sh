
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

SCRIPTPATH=$(get_script_dir)
echo "Current Starting Directory on Invocation of Script is ="$(pwd)

cd "$SCRIPTPATH"
curpath=$SCRIPTPATH

echo "Script Loaded From: " $SCRIPTPATH
echo "Script is running under userid: " jenkins
echo "current path is now: " $curpath

nohup java -jar mgrweb-0.0.1-SNAPSHOT.jar > mgrweb.out &
