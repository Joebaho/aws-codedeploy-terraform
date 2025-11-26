pipeline {
    
    agent any

    environment {
        AWS_REGION = "us-west-2"
        S3_BUCKET  = "codedeploy-project-bucket-backup01"   
        APP_NAME   = "codedeploy-project-app"              
        GROUP_NAME = "codedeploy-project-dg"             
    }

    parameters {
        booleanParam(
            name: 'DESTROY_AFTER_BUILD',
            defaultValue: false,
            description: 'Destroy infrastructure after successful build and deployment'
        )
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init/Plan/Apply') {
            steps {
                withAWS(credentials: 'aws-creds', region: env.AWS_REGION) {
                    sh """
                        terraform init
                        terraform validate
                        terraform refresh
                        terraform plan -out=tfplan
                        terraform apply -auto-approve tfplan

                    """
                }
            }
        }

        stage('Package Application') {
            steps {
                sh """
                    zip -r deployment.zip appspec.yml scripts/ templates/
                """
            }
        }

        stage('Upload to S3') {
            steps {
                withAWS(credentials: 'aws-creds', region: env.AWS_REGION) {
                    sh """
                        aws s3 cp deployment.zip s3://$S3_BUCKET/deployment.zip
                    """
                }
            }
        }

        stage('Trigger CodeDeploy') {
            steps {
                withAWS(credentials: 'aws-creds', region: env.AWS_REGION) {
                    sh """
                        aws deploy create-deployment \
                          --application-name $APP_NAME \
                          --deployment-group-name $GROUP_NAME \
                          --s3-location bucket=$S3_BUCKET,bundleType=zip,key=deployment.zip
                    """
                }
            }
        }

        stage('Destroy Infrastructure') {
            when {
                expression { params.DESTROY_AFTER_BUILD == true }
            }
            steps {
                script {
                    // Safety confirmation
                    def userInput = input(
                        id: 'userInput',
                        message: '🚨 CONFIRM INFRASTRUCTURE DESTRUCTION 🚨',
                        description: 'This will DESTROY ALL resources created by Terraform',
                        parameters: [
                            [
                                $class: 'BooleanParameterDefinition',
                                defaultValue: false,
                                description: 'I understand this will DELETE ALL AWS RESOURCES (EC2, Load Balancer, ASG, etc.)',
                                name: 'CONFIRM_DESTROY'
                            ],
                            [
                                $class: 'TextParameterDefinition',
                                defaultValue: 'NO',
                                description: 'Type "DESTROY" to confirm deletion',
                                name: 'CONFIRM_TEXT'
                            ]
                        ]
                    )
                    
                    if (userInput['CONFIRM_DESTROY'] == true && userInput['CONFIRM_TEXT'] == 'DESTROY') {
                        echo "✅ Confirmed - Destroying infrastructure..."
                        
                        withAWS(credentials: 'aws-creds', region: env.AWS_REGION) {
                            sh """
                                echo "Starting infrastructure destruction..."
                                terraform destroy -auto-approve
                                echo "Infrastructure destruction completed successfully"
                            """
                        }
                    } else {
                        echo "❌ Destroy cancelled - confirmation not provided"
                        currentBuild.result = 'SUCCESS'
                    }
                }
            }
        }

    }

    post {
        always {
            echo "cleaning workspace"
            cleanWs()
        }   
    }
}
