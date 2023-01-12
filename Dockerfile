{
pipeline {
   agent any
      environment {
         registryCredential = 'gitali'
         registryCredentialAli = 'containerali'
         registry = 'registry-intl-vpc.ap-southeast-5.aliyuncs.com/testdockerrepo/blogrepo'
         registryUrl = 'https://registry-intl-vpc.ap-southeast-5.aliyuncs.com/testdockerrepo/blogrepo'
         dockerImage = ''
      }
   options {
      skipDefaultCheckout(true)
   }
   stages {
      stage('Checkout SCM') {
         steps {
            echo '> Checking out the source control ...'
            checkout scm
         }
      }
      stage('List Git Files') {
         steps {
            echo '> List the File ...'
            sh 'ls -l'    
         }
      }
      stage('Build') {
         steps {
           echo '> Build Image ...'
           script {
               dockerImage = docker.build registry + ":$BUILD_NUMBER"
           }
         }
      }
      stage('Deploy Image') {
         steps{
            script {
               docker.withRegistry( registryUrl, registryCredentialAli) {
               dockerImage.push()
               }
            }
         }
      }
      stage('Remove Unused docker image') {
         steps{
           sh "docker rmi -f $registry:$BUILD_NUMBER"
         }
      }
   }
}
