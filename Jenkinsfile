pipeline {
    
	agent any

    stages{
        stage("Clone code from GitHub") {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/PSSahana/NewOne.git';
                }
            }
        }
        
        stage('BUILD'){
            steps {
                sh 'mvn clean install -DskipTests'
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

	    stage('UNIT TEST'){
            steps {
                sh 'mvn test'
            }
        }
       
        
        stage('Quality Gate Status Check'){
            steps{
                script{
                    withSonarQubeEnv('sonar-server') { 
                        sh "mvn sonar:sonar"
                    }
                    timeout(time: 1, unit: 'HOURS') {
                    def qg = waitForQualityGate()
                    if (qg.status != 'OK') {
                       error "Pipeline aborted due to quality gate failure: ${qg.status}"
                    }
                    }
		            sh "mvn clean install"
                }
                }  
        }
        stage("Publish to Nexus Repository Manager") {
            steps{
                    nexusArtifactUploader artifacts: [
                        [artifactId: 'webapp', 
                        classifier: '', 
                        file: '/var/lib/jenkins/workspace/latest/webapp/target/webapp.war', 
                        type: 'war']
                        ], 
                        credentialsId: 'ad', 
                        groupId: 'com.example.maven-project', 
                        nexusUrl: '10.0.13.242:8081', 
                        nexusVersion: 'nexus3', 
                        protocol: 'http', 
                        repository: 'pipelinedemo', 
                        version: "1.0-SNAPSHOT"

               
            }
        }
         stage('Deploy tomcat') {
            steps{
                script{
                    sshagent(['tomcat-deploy']) {
                    sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/latest/webapp/target/*.war ubuntu@10.0.10.19:/opt/tomcat/webapps/'
                    }
                }
            }
            
        
   	    }
        
        


        


    }


}
