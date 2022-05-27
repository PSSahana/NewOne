pipeline {
    
	agent any
/*	
	tools {
        maven "maven3"
    }
	
    environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "10.0.13.242:8081"
        NEXUS_REPOSITORY = "pipelinedemo"
        NEXUS_CREDENTIAL_ID = "nexus_id"
    
    }
*/	
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
        stage('Deploy tomcat') {
            steps{
                script{
                    sshagent(['tomcat-deploy']) {
                    sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/latest/webapp/target/*.war ubuntu@10.0.10.19:/opt/tomcat/webapps/'
                    }
                }
            }
            
        
   	    }
        
        stage('Quality Gate Statuc Check'){
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
        /*
        stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    def pom = readMavenPom  file:"pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version} ARTVERSION";
                     nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } 
		    else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
               
            }
        



        }*/
        stage("Publish to Nexus Repository Manager") {
            steps{
                    /*def mavenPom = readMavenPom  file: 'pom.xml'*/
                    nexusArtifactUploader artifacts: [
                        [artifactId: 'webapp', 
                        classifier: '', 
                        file: "target/webapp.war", 
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


        


    }


}
