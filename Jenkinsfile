pipeline {
  agent any
  stages {
    stage('First Stage') {
      parallel {
        stage('First Stage') {
          steps {
            sleep 1
          }
        }
        stage('') {
          steps {
            sleep 2
          }
        }
      }
    }
  }
}