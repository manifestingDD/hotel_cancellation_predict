pipeline{
    agent any

    environment{
        // Step 4
        VENV_DIR = 'venv'  

        // Step 5
        GCP_PROJECT = 'mlfool'    //Project Name on GCP
        GCLOUD_PATH = '/var/jenkins_home/google-cloud-sdk/bin'
    }

    stages{

        // Step 2
        stage('Cloning Github repo to Jenkins'){
            steps{
                script{
                    echo 'Cloning Github repo to Jenkins...'  //echo message will be shown on the Jenkins terminal
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-hotel-token', url: 'https://github.com/manifestingDD/hotel_cancellation_predict.git']])
                }
            }
        }

        // Step 4
        stage('Setting up our virtual environment and installing dependencies'){
            steps{
                script{
                    echo 'Setting up our virtual environment and installing dependencies...'  //echo message will be shown on the Jenkins terminal
                    //sh for shell command, in Linux Machine
                    sh '''   
                    python -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    pip install --upgrade pip
                    pip install -e .
                    '''
                }
            }
        }

        // Step 5
        stage('Building and pushing docker image to GCR'){
            steps{
                //  GCP knows {path, project credentials, project name, docker config, create image, push image}
                withCredentials([file(credentialsId: 'gcp-key-hotel-cancellation', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]){
                    script{
                        echo 'Building and pushing docker image to GCR ...'
                        sh '''
                        export PATH=$PATH:${GCLOUD_PATH}
                        
                        gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

                        gcloud config set project ${GCP_PROJECT}

                        gcloud auth configure-docker --quiet

                        docker build -t gcr.io/${GCP_PROJECT}/hotel-cancel-predict:latest .

                        docker push gcr.io/${GCP_PROJECT}/hotel-cancel-predict:latest

                        '''
                    }
                }
            }
        }

        // Step 6
        stage('Deploy to Google Cloud Run'){
            steps{
                withCredentials([file(credentialsId: 'gcp-key-hotel-cancellation', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]){
                    script{
                        echo 'Deploying to Google Cloud Run ...'
                        sh '''
                        export PATH=$PATH:${GCLOUD_PATH}
                        
                        gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

                        gcloud config set project ${GCP_PROJECT}

                        gcloud run deploy hotel-cancel-predict \
                            --image=gcr.io/${GCP_PROJECT}/hotel-cancel-predict:latest \
                            --platform=managed \
                            --region='us-central-1' 
                            --allow-unauthenticated

                        '''
                    }
                }
            }
        }
    }

}