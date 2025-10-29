pipeline{
    agent any

    stages{
        stage('Cloning Github repo to Jenkins'){
            steps{
                script{
                    echo 'Cloning Github repo to Jenkins...'  //echo message will be shown on the Jenkins terminal
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-hotel-token', url: 'https://github.com/manifestingDD/hotel_cancellation_predict.git']])
                }
            }
        }
    }

}