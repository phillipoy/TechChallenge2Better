pipeline {
    agent any

    environment {
        AWS_REGION     = 'us-east-1'
        ECR_REGISTRY   = '236898858566.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPOSITORY = 'eks-project-development-app'
        EKS_CLUSTER    = 'eks-project-Development-eks'
        IMAGE_TAG      = "${BUILD_NUMBER}"
        IMAGE_URI      = "${ECR_REGISTRY}/${ECR_REPOSITORY}:${IMAGE_TAG}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Tools') {
            steps {
                sh '''
                    git --version
                    docker --version
                    aws --version
                    kubectl version --client
                    helm version
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker buildx build \
                      --platform linux/amd64 \
                      -t ${IMAGE_URI} \
                      --load \
                      .
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password \
                      --region ${AWS_REGION} | \
                    docker login \
                      --username AWS \
                      --password-stdin ${ECR_REGISTRY}
                '''
            }
        }

        stage('Push Image') {
            steps {
                sh '''
                    docker push ${IMAGE_URI}
                '''
            }
        }

        stage('Configure EKS') {
            steps {
                sh '''
                    aws eks update-kubeconfig \
                      --region ${AWS_REGION} \
                      --name ${EKS_CLUSTER}

                    kubectl get nodes
                '''
            }
        }

        stage('Validate Helm Chart') {
            steps {
                sh '''
                    helm lint kubernetes/application

                    helm template application kubernetes/application \
                      --set image.repository=${ECR_REGISTRY}/${ECR_REPOSITORY} \
                      --set image.tag=${IMAGE_TAG} \
                      > /tmp/application-rendered.yaml
                '''
            }
        }

        stage('Deploy with Helm') {
            steps {
                sh '''
                    helm upgrade --install application kubernetes/application \
                      --set image.repository=${ECR_REGISTRY}/${ECR_REPOSITORY} \
                      --set image.tag=${IMAGE_TAG} \
                      --wait \
                      --timeout 5m
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    kubectl rollout status deployment/application --timeout=5m
                    kubectl get pods -o wide
                    kubectl get svc
                    kubectl get ingress
                    kubectl get hpa
                '''
            }
        }
    }

    post {
        success {
            echo "Deployment completed successfully with image tag ${IMAGE_TAG}"
        }

        failure {
            echo "Pipeline failed. Review the Jenkins stage logs."
        }

        always {
            sh '''
                docker logout ${ECR_REGISTRY} || true
            '''
        }
    }
}