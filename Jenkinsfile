pipeline{
    agent any
        parameters {
            booleanParam(name: 'PLAN_TERRAFORM', defaultValue: false, description: 'Check to plan Terraform changes')
            booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
            booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to apply Terraform changes')
    }
        stages {
        stage('Clone Repository') {
            steps {
                deleteDir()

                git branch: 'main',
                    url: 'https://github.com/zablon-oigo/ec2-state-change-terraform.git'

                sh "ls -lart"
            }
        }
}
stage('Terraform Init') {
    steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-crendentails']]){
            sh 'echo "=================Terraform Init=================="'
            sh 'terraform init'
        }
    }
}
stage('Terraform Plan') {
    steps {
        script {
            if (params.PLAN_TERRAFORM) {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-crendentails']]){
                    sh 'echo "=================Terraform Plan=================="'
                    sh 'terraform plan'
                }
            }
        }
    }
}
stage('Terraform Apply') {
    steps {
        script {
            if (params.APPLY_TERRAFORM) {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-crendentails']]){
                    sh 'echo "=================Terraform Apply=================="'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}
stage('Terraform Destroy') {
    steps {
        script {
            if (params.DESTROY_TERRAFORM) {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-crendentails']]){
                    sh 'echo "=================Terraform Destroy=================="'
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
}