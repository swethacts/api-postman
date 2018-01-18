pipeline {
  agent none
  stages {
    stage('API Testing') {
	  agent { docker 'node:7' } 
      steps {
			parallel(
				NewmanAPI: {
					slackSend color: "cceef9", message: "`Creating Node Docker container for Postman`"
					slackSend color: "cceef9", message: "`Starting API Test Execution. Job Details: ${env.JOB_NAME} ${env.BUILD_NUMBER}` (<${env.BUILD_URL}|Open>)"
							
					sh '''
						echo "Starting"
						chmod 777 ./ci/scripts/functional-test.sh
						./ci/scripts/functional-test.sh
					'''
					slackSend color: "cceef9", message: "`Archieving test results...`"

					junit 'tests/*.xml'		
					sh 'echo "Complete"'
					slackSend color: "cceef9", message: "`API Test Execution Complete. Job URL:` (<${env.BUILD_URL}|Open>)"
					slackSend color: "cceef9", message: "`Destroying Docker container`"		
				},
				Notifications: {
					sh 'echo "testing"'		
				}
			)
		}	 
    }
  }
}
