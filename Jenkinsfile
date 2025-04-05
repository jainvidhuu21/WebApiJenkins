pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'master', url: 'https://github.com/jainvidhuu21/WebApiJenkins'
            }
        }

        stage('Terraform Init') {
            steps {
               bat 'terraform init -upgrade'
            }
        }

        stage('Terraform Plan') {
            steps {
                bat 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                bat 'terraform apply -auto-approve'
            }
        }

        stage('Build .NET App') {
            steps {
                dir('WebApiJenkins') {
                    bat 'dotnet publish -c Release -o publish'
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                bat '''
                    powershell Compress-Archive -Path WebApiJenkins\\publish\\* -DestinationPath publish.zip -Force
                    az login --service-principal -u %ARM_CLIENT_ID% -p %ARM_CLIENT_SECRET% --tenant %ARM_TENANT_ID%
                    az webapp deployment source config-zip --resource-group jenkins-vidhi1-rg --name jenkins-vidhi-app21 --src publish.zip
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
