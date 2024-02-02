pipeline{
    agent { label 'Jenkins' }
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
                sh 'mvn clean install -U'
            }
        }
        stage('SonarQube'){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-api') {
                    sh 'mvn clean package sonar:sonar'

                    }

               }

            }
        }
        stage('Quality Gate Status'){
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-api'
                }
            }
        }
        stage("Nexus upload"){
            steps{
                script{

                    def mavenPom = readMavenPom file: 'pom.xml'
                    nexusArtifactUploader artifacts:
                     [
                        [
                            artifactId: 'my-webapp',
                            classifier: '',
                            file: 'target/my-webapp-2.0.0-SNAPSHOT.war',
                            type: 'war'
                        ]
                     ],
                    credentialsId: 'nexus-auth',
                    groupId: 'com.example',
                    nexusUrl: '15.206.195.205:8081',
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    repository: 'Demoapp_snapshot',
                    version: "${mavenPom.version}"

                }
            }
        }
        stage('Docker Build'){
                steps{
                    script{
                        sh "sudo docker buildx build -t kumarolipi/jenkins-img ."
                   }

                }
            }
    }
}
