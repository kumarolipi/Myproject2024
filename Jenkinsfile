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

                    def readPomVersion = readMavenPom file: 'pom.xml'
                    def nexusRepo = readPomVersion.version.endsWith("SNAPSHOT") ? "Demoapp_snapshot" : "Demoapp_release"
                    nexusArtifactUploader artifacts:
                     [
                        [
                            artifactId: 'my-webapp',
                            classifier: '',
                            file: 'target/my-webapp-1.0.0-SNAPSHOT.war',
                            type: 'war'
                        ]
                     ],
                    credentialsId: 'nexus-auth',
                    groupId: 'com.example',
                    nexusUrl: '3.109.153.205:8081',
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    repository: 'Demoapp_Mixed',
                    version: "${readPomVersion.version}"

                }
            }
        }
        stage('Docker Build'){
                steps{
                    script{
                        sh "sudo docker image build -t $JOB_NAME:v1.$BUILD_ID ."
                        sh "sudo docker image tag $JOB_NAME:v1.$BUILD_ID kumarolipi/$JOB_NAME:v1.$BUILD_ID"
                        sh "sudo docker image tag $JOB_NAME:v1.$BUILD_ID kumarolipi/$JOB_NAME:latest"
                   }

                }
            }
        stage('Docker image push'){
                steps{
                    script{

                    withCredentials([string(credentialsId: 'Docker-hub-pass', variable: 'hub-login')]) {

                        sh "sudo docker login"
                        sh 'sudo docker image push kumarolipi/$JOB_NAME:v1.$BUILD_ID'
                        sh 'sudo docker image push kumarolipi/$JOB_NAME:latest'
                                }
                        sh 'sudo docker rmi kumarolipi/$JOB_NAME:v1.$BUILD_ID'

                            }

                        }
                     }
        stage('Deploy to Kubernetes') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'kubeconfig', namespace: '', serverUrl: 'https://172.31.45.211:6443']]) {
                    sh "kubectl get nodes -o wide"
                script{
                    try{
                        sh "kubectl apply -f jenkins-deployment.yaml"
                    }catch(error){
                        sh "kubectl create -f jenkins-deployment.yaml"
                        }
                        sh "kubectl get all -n dev -o wide"
                        sh "echo http://13.127.9.137:30000"
                        sh "echo http://65.0.32.222:30000"
                     }

                }
            }
        }
    }
}
