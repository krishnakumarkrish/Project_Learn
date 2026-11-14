pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                // Pulls code from your GitHub repository using your credentials
                git branch: 'main', credentialsId: 'Cjenkins', url: 'https://github.com/krishnakumarkrish/Project_Learn.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Dynamically resolves the SonarScanner tool installation path
                    def scannerHome = tool 'SonarScanner'
                    withSonarQubeEnv('SonarQube-Server') {
                        // Executes the scanner using the resolved path and project properties file
                        sh "${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

        stage('Stop Old Container') {
            steps {
                // Safely stops and removes the old container if it exists, ignoring errors if it doesn't
                sh 'docker stop portfolio_container || true'
                sh 'docker rm portfolio_container || true'
            }
        }

        stage('Clear old Docker Image') {
            steps {
                // Removes the old docker image
                sh 'docker rmi portfolio || true'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Builds the updated Docker image and tags it as portfolio:latest
                sh 'docker build --no-cache -t portfolio:latest .'
            }
        }

        Stage('Run New Container') {
            steps {
                // Runs the new container on port 8090 mapped to port 80 inside the container
                sh 'docker run -d --name portfolio_container -p 8090:80 portfolio:latest'
            }
        }
    }
}