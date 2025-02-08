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
                    url: ''

                sh "ls -lart"
            }
        }
}
}