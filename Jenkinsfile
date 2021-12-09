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
						def result = sh script: './build/findfile.sh ${inputdir} ${filetype} || echo error', returnStdout: true
						def error = result.endsWith("error")
						sh 'echo $result'
						sh 'echo $error'
                    }
                }
            }
        }
    }
}        