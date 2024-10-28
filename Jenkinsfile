pipeline {
    agent any   
    environment {
     NAME = "webapp"
     VERSION = "${env.BUILD_ID}-${env.GIT_COMIT}"
     IMAGE_REPO = "asrafbd"
     //ARGOCD_TOKEN = credentials('argocd-token')
     GITHUB_TOKEN = credentials('github-token1')
     }

    stages {
        stage('Unit Tests') {
            steps {
                echo 'Unit tests if applicable.'
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t ${NAME} .'
                sh 'docker tag ${NAME}:latest ${IMAGE_REPO}/${NAME}:${VERSION}'
            }
        }

        stage('Push Image') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub') {
                 
                sh 'docker push ${IMAGE_REPO}/${NAME}:${VERSION}'
            }
           }
        }
    
        stage('Clone/Pull Repo') {
            steps {
              script {
                if (fileExists('argocd-cicd')) {
                 
                echo 'Cloud repo already esists - Pulling latest changes'
                dir("argocd-cicd") {
                 sh 'git pull'
            }

           } else {
            echo 'Repo does not exists - Clone the repo'
            sh 'git clone -b master https://github.com/asrafbd/argocd-cicd.git'

           }
           }
         }
        }

      stage('update Manifest') {
            steps { 
                dir("argocd-cicd/jenkins-demo") {
                sh 'sed -i s#asrafbd/webapp.*#${IMAGE_REPO}/${NAME}:${VERSION}#g deployment.yaml'
                sh 'cat deployment.yaml'
            }
           }
          }


       stage('Commit and Push') {
            steps { 
                dir("argocd-cicd/jenkins-demo") {
                sh "git config --global user.email 'jekins@ci.com'"
                sh 'git remote set-url origin https://$GITHUB_TOKEN@github.com/asrafbd/argocd-cicd'
                sh 'git checkout master'
                sh 'git add -A'
                sh 'git commit -am "updated image version for Build - $VERSION"'
                sh 'git push origin master'
            }

            }
           }
            //stage('Pull Request') {
            //steps { 
            //    sh 'bash pr.sh'
            //}
           //}
        }
}
