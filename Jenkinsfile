pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-cred')
        AWS_SECRET_ACCESS_KEY = credentials('aws-cred')
        S3_BUCKET = 'my-artifacts-buckets'
        CODEDEPLOY_APPLICATION = 'MyWebApp'
        CODEDEPLOY_DEPLOYMENT_GROUP = 'MyWebApp-DeploymentGroup'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git brancph: 'main', url: 'https://github.com/hussham98/SimpleWebApp.git'
            }
        }

        stage('Build Application') {
            steps {
                sh 'zip -r MyApp.zip appspec.yml index.html start_server.sh'
            }
        }

        stage('Upload to S3') {
            steps {
                sh 'aws s3 cp MyApp.zip s3://$S3_BUCKET/'
            }
        }

        stage('Check Active Deployments') {
            steps {
                script {
                    
                    def activeDeployments = sh(script: "aws deploy list-deployments --application-name $CODEDEPLOY_APPLICATION --deployment-group-name $CODEDEPLOY_DEPLOYMENT_GROUP --query 'deployments[?status==`InProgress`]' --output json", returnStdout: true).trim()
                    
                    if (activeDeployments != "[]") {
                        echo 'An active deployment is already in progress. Skipping new deployment.'
                        currentBuild.result = 'SUCCESS' 
                        error('Skipping deployment due to an active deployment in progress.')
                    }
                }
            }
        }

        stage('Deploy to AWS CodeDeploy') {
            steps {
                script {
                    def appSpec = readFile('appspec.yml')
                    
                    sh 'aws deploy create-deployment --application-name $CODEDEPLOY_APPLICATION --deployment-group-name $CODEDEPLOY_DEPLOYMENT_GROUP --s3-location bucket=$S3_BUCKET,key=MyApp.zip,bundleType=zip'
                }
            }
        }
    }
    
    post {
        failure {
            echo 'Deployment failed. Check the logs for details.'
        }
    }
}
