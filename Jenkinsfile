pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/jainvidhuu21/WebApiJenkins'
            }
        }

        stage('Clean .terraform') {
            steps {
                echo 'Cleaning existing .terraform folder...'
                bat 'rmdir /s /q .terraform || echo .terraform does not exist'
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                bat '''
                    terraform plan -input=false -no-color ^
                    -var "client_id=%ARM_CLIENT_ID%" ^
                    -var "client_secret=%ARM_CLIENT_SECRET%" ^
                    -var "tenant_id=%ARM_TENANT_ID%" ^
                    -var "subscription_id=%ARM_SUBSCRIPTION_ID%" ^
                    -lock=false -parallelism=1 -refresh=true -debug
                '''
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    return currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                input message: 'Apply Terraform changes?', ok: 'Apply'
                bat '''
                    terraform apply -auto-approve ^
                    -var "client_id=%ARM_CLIENT_ID%" ^
                    -var "client_secret=%ARM_CLIENT_SECRET%" ^
                    -var "tenant_id=%ARM_TENANT_ID%" ^
                    -var "subscription_id=%ARM_SUBSCRIPTION_ID%"
                '''
            }
        }

        stage('Build .NET App') {
            steps {
                bat 'dotnet build WebApi/WebApi.csproj --configuration Release'
            }
        }

        stage('Deploy to Azure') {
            steps {
                echo 'Deploying .NET App to Azure...'
                // Add your Azure deployment steps here
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed. Check the logs above ☝️ for details."
        }
        success {
            echo "Pipeline executed successfully 🎉"
        }
    }
}
