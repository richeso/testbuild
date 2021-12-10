def continueSteps = true
def appname = "testbuild"
def giturl = "git@github.com:richeso/${appname}.git"

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
        
        stage("Test2") {
            steps {
                sh script:'''
                    #!/usr/bin/env bash
                    curdir=$(pwd)
                    echo "This is starting directory in impromptu script $curdir"
                    [ -d ios ] && rm -rf ios
                    [ -d ios ] || mkdir ios
                    cd ./ios
                    echo "This is current working directory now: $(pwd)"
                    cd ..
                    cd ../BuildMsweb/target
                	for file in *.notthere
                	do
                    # do something on "$file"
                 		echo "jar file found: $file"
                 		foundfile=$file
                 		modfile=$(echo "$file" | sed -r 's/[-.]+/|/g')
                 		echo "modfile: " $modfile
                 		appname=$(echo $modfile | awk -F'|' '{print $1}')
                 		break
                	done
                	echo "This is file name:"$foundfile
                	echo "This is appname:"$appname
                	if [ -f "$foundfile" ]; then
                        echo "$foundfile exists."
                    else 
                        echo "$foundfile does not exist."
                    fi
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
    }
}