pipeline {
    agent any

    tools {
        // Correct tool identifier for SonarQube Runner in Jenkins declarative pipelines
        sonarRunner 'SonarScanner'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Pulls code from your GitHub repository using your credentials
                git branch: 'main', credentialsId: 'Cjenkins', url: 'https://github.com/krishnakumarkrish/Project_Learn.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Connects to the SonarQube server configuration named 'SonarQube-Server'
                withSonarQubeEnv('SonarQube-Server') {
                    // Executes the scanner using the properties file in the workspace
                    sh 'sonar-scanner'
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

        stage('Run New Container') {
            steps {
                // Runs the new container on port 8090 mapped to port 80 inside the container
                sh 'docker run -d --name portfolio_container -p 8090:80 portfolio:latest'
            }
        }
    }
}