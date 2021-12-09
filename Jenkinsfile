def continueSteps = true

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
        