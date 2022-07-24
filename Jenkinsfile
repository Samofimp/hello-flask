pipeline {
    agent none
    stages {
        stage('SCM stage') {
            agent { label 'slave && default' } 
            steps {
                git url: 'https://github.com/Samofimp/hello-flask.git'
                stash includes: '**', name: 'git-repo' 
            }
        }
        stage('Build stage') {
            agent { label 'slave && python' } 
            steps {
                container('python') {
                    dir('hello-flask') {
                        unstash 'git-repo'
                        sh """
                        pip install -r requirements.txt
                        python add-build-num.py ${BUILD_NUMBER}
                        tar -zcvf hello-${BUILD_NUMBER}.tar.gz application.py requirements.txt
                        """
                        stash includes: "hello-${BUILD_NUMBER}.tar.gz", name: 'app'
                    }
                }
            }
        }
        stage('Post-build stage') {
            agent { label 'slave && default' } 
            steps {
                unstash 'app'
                archiveArtifacts artifacts: "hello-${BUILD_NUMBER}.tar.gz"
            }
        }
        stage('Build Docker image and publish') {
            agent { label 'slave && docker' }
            steps {
                container('docker') {
                    unstash 'app'
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'TOKEN')]) {
                        sh 'docker build -t $USERNAME/hello-flask:latest .'
                        sh 'docker push docker login -u $USERNAME -p $TOKEN'
                    }
                }
            }
        }
    }
}
