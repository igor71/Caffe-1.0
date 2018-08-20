pipeline {
  agent {label 'yi-caffe-tf'}
    stages {
        stage('Build Cafee 1.0 Docker Image') {
            steps {
	       sh 'docker build -f Dockerfile -t yi/caffe:gpu .'  
            }
        }
	stage('Test The yi/caffe:gpu Docker Image') { 
            steps {
                sh '''#!/bin/bash -xe
		    echo 'Hello, YI-CAFFE!!'
                    image_id="$(docker images -q yi/caffe:gpu)"
                      if [[ "$(docker images -q yi/caffe:gpu 2> /dev/null)" == "$image_id" ]]; then
                          docker inspect --format='{{range $p, $conf := .RootFS.Layers}} {{$p}} {{end}}' $image_id
                      else
                          echo "It appears that current docker image corrapted!!!"
                          exit 1
                      fi 
                   ''' 
            }
        }
        stage('Build The yi/caffe:gpu-tf Docker Image ') {
            steps {
	       sh 'docker build -f Dockerfile.tf -t yi/caffe:gpu-tf .'  
            }
        }
	stage('Test The yi/caffe:gpu-tf Docker Image') { 
            steps {
                sh '''#!/bin/bash -xe
		   echo 'Hello, YI-CAFFE-TF!!!'
                    image_id="$(docker images -q yi/caffe:gpu-tf)"
                      if [[ "$(docker images -q yi/caffe:gpu-tf 2> /dev/null)" == "$image_id" ]]; then
                          docker inspect --format='{{range $p, $conf := .RootFS.Layers}} {{$p}} {{end}}' $image_id
                      else
                          echo "It appears that current docker image corrapted!!!"
                          exit 1
                      fi 
                   ''' 
		    }
		}
	 stage('Save & Load Docker Images') { 
            steps {
                sh '''#!/bin/bash -xe
		        echo 'Saving Docker image into tar archive'
                        docker save yi/caffe:gpu-tf | pv | cat > "$WORKSPACE/yi-caffe-gpu-tf.tar"
			
                        echo 'Remove Original Docker Image' 
			CURRENT_ID=$(docker images | grep -E '^yi/caffe.*gpu-tf' | awk '{print $3}')
			docker rmi -f $CURRENT_ID
			
                        echo 'Loading Docker Image'
                        pv $WORKSPACE/yi-caffe-gpu-tf.tar | docker load
			docker tag $CURRENT_ID yi/caffe:gpu-tf
                        
                        echo 'Removing temp archive.'  
                        rm $WORKSPACE/yi-caffe-gpu-tf.tar
				
			echo 'Removing yi/caffe:gpu Docker Image'
			docker rmi -f yi/caffe:gpu
                   ''' 
		    }
		}
 }
	post {
            always {
               script {
                  if (currentBuild.result == null) {
                     currentBuild.result = 'SUCCESS' 
                  }
               }
               step([$class: 'Mailer',
                     notifyEveryUnstableBuild: true,
                     recipients: "igor.rabkin@xiaoyi.com",
                     sendToIndividuals: true])
            }
         } 
}
