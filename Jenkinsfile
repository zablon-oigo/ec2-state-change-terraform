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

}