pipeline{
    agent any
    stages{
        stage('Git Checkout'){
            steps{
                git 'https://github.com/kumarolipi/Myproject2024.git'
            }
        }
        stage('Unit Test'){
            steps{
                sh 'mvn test'
            }
        }
        stage('Integration Test'){
            steps{
                sh 'mvn verify -DskipUnitTests'
            }
        }
        stage('Maven Build'){
            steps{
                sh 'mvn clean install'
            }
        }

    }
}