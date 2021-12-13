def continueSteps = true
def appname = "testbuild"
def giturl = "git@github.com:richeso/${appname}.git"
def workingdir=""
def jarfile=""
def user="mapr"
def rootdir="/user"
def writeservice() {
     sh script:'''
                    #!/usr/bin/env bash
                    echo "*** Now in writeservice ***"
                    echo "*** appname is:  $varappname "
            		app="$varappname"
            		jarf="$varjarfile"
            		homedir="$varrootdir"
            		usr="$varuser"
                    curdir=$(pwd)
                	cd $curdir
                	echo "creating file: $app.service in directory: $curdir"
cat << EOF > $app.service
[Unit]
Description=Volume Request Rest Web
After=syslog.target

[Service]
User=$homedir
WorkingDirectory=/home/mapr/$app/scripts
ExecStart=/usr/lib/jvm/java/bin/java -jar /$homedir/$app/scripts/$jarf
ExecStop=/bin/kill -15 $MAINPID
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target

EOF
                    ls -l
                    cat $app.service
                    
                '''
}

def writescript() {
     sh script:'''
                    #!/usr/bin/env bash
                    echo "*** Now in writescript ***"
                    echo "*** appname is:  $varappname "
            		app="$varappname"
            		jarf="$varjarfile"
            		homedir="$varrootdir"
            		usr="$varuser"
                    curdir=$(pwd)
                	cd $curdir
                	echo "creating file: run"$app".sh in directory: $curdir"
cat << EOF > run"$app".sh
#!/bin/bash

nohup java -jar $jarf > $app.out &
EOF

                    ls -l
                    cat run"$app".sh
                    
                '''
}
pipeline {
    agent any
    
    tools {
        maven "maven3.8.4"
        jdk "jdk8"
    }

    options {
        skipDefaultCheckout()
    }

    stages {

        stage("Setup parameters") {
            steps {
                script {
                    properties([
                        parameters([
                            booleanParam(name: "REFRESH", description: 'Refresh workspace From SCM', defaultValue: false),
                            choice(choices: ['./target', './build'], description: 'inputdir', name: 'inputdir'),
                            choice(choices: ['txt', 'sh'], description: 'filetype', name: 'filetype'),
                            gitParameter (branchFilter: 'origin/(.*)', defaultValue: 'master', name: 'BRANCH', type: 'PT_BRANCH')
                        ])
                    ])
                }
            }
        }

        stage('Initialize') {
            steps {
                // Get the Maven tool.
                // ** NOTE: This 'M3' Maven tool must be configured
                // **       in the global configuration.
                 sh 'java -version'
                 sh 'mvn -version'
                 script {
                    if (params.REFRESH) {
                        sh 'echo checking out on REFRESH in order to update workspace'                   
                        git branch: "${params.BRANCH}",  url: "${giturl}"
                       	// jenkins pipeline  script invoation
						result = sh script: './build/findfile.sh ${inputdir} ${filetype} || echo error', returnStdout: true
						error = result.endsWith("error")
						echo "${result}"
						echo "${error}"
                    }
                }
            }
        }
        
        stage("Test1-writefile") {
            steps {
                sh script:'''
                    #!/usr/bin/env bash
                    curdir=$(pwd)
                	cd $curdir
                	echo "creating temp file: mytempfile.txt in directory: $curdir"
cat << EOF > mytempfile.txt
The current working directory is: $PWD
You are logged in as: $(whoami)
These contents will be written to the file.
This line is indented.
This is line 3
EOF
                    ls -l
                    cat mytempfile.txt
                    
                '''
            }
        }
        stage("Test2-createdir") {
            steps {
                sh script: '''
                #!/usr/bin/env bash
                curdir=$(pwd)
                echo "This is starting directory in impromptu script $curdir"
                [ -d ios ] && rm -rf ios
                [ -d ios ] || mkdir ios
                cd ./ios
                echo "This is current working directory now: $(pwd)"
                '''
            }
        }
        stage("Test3-checkfile") {
            steps {
               script {
                  def foundfile = sh (returnStdout: true, script: '''
                        #!/usr/bin/env bash
                        curdir=$(pwd)
                        cd ../BuildMgrweb/target
                    	for file in *.jar
                    	do
                        # do something on "$file"
                     		foundfile=$file
                     		modfile=$(echo "$file" | sed -r 's/[-.]+/|/g')
                     		appname=$(echo $modfile | awk -F'|' '{print $1}')
                     		major=$(echo $modfile | awk -F'|' '{print $2}')
                     		minor=$(echo $modfile | awk -F'|' '{print $3}')
                     		patch=$(echo $modfile | awk -F'|' '{print $4}')
                     		build=$(echo $modfile | awk -F'|' '{print $5}')
                     		type=$(echo $modfile | awk -F'|' '{print $6}')
                     		break
                    	done
                    	echo $appname
                    	echo $major
                    	echo $minor
                    	echo $patch
                    	echo $build
                    	echo $type
                        echo $foundfile
                    ''').split()
                def commit = sh (returnStdout: true, script: '''echo hi
                echo bye | grep -o "e"
                date
                echo lol''').split()
                echo "commit-1: ${commit[-1]} "
                echo "commit0: ${commit[0]} "
                echo "commit1: ${commit[1]} "
                echo "commit2: ${commit[2]} "
                echo "foundfile-1: ${foundfile[-1]}"
                echo "foundfile0: ${foundfile[0]}"
                echo "foundfile1: ${foundfile[1]}"
                echo "foundfile2: ${foundfile[2]}"
                echo "foundfile3: ${foundfile[3]}"
                echo "foundfile4: ${foundfile[4]}"
                echo "foundfile5: ${foundfile[5]}"
                echo "foundfile6: ${foundfile[6]}"
                jarfile="${foundfile[-1]}"
                appname="${foundfile[0]}"
               }
            }
        }
     
    stage("Test4-End") {
        steps {
            script {
                echo "Test4- End: jarfile is: $jarfile"
                echo "Test4- End: appname is: $appname"
                env.varjarfile="$jarfile"
                env.varappname="$appname"
                env.varuser="$user"
                env.varrootdir="$rootdir"
                writeservice()
                writescript()
                echo "End-test-4"
            }
        }
    }
    }
}