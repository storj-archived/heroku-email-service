node('node') {
  try {

    stage 'Checkout'

      checkout scm

    stage 'Test'

      sh """#!/bin/bash -e
        source '/var/lib/jenkins/.nvm/nvm.sh'
        node -v
        git clean -fdx
        npm install
        npm test
      """

    stage 'Build Docker'

      sh "git rev-parse --short HEAD > .git/commit-id"
      def commit_id = readFile('.git/commit-id').trim()
      sh "./dockerfiles/build.sh storjlabs/heroku-email-service:${env.BUILD_ID} storjlabs/heroku-email-service:${commit_id} storjlabs/heroku-email-service:latest"
      sh "./dockerfiles/push.sh storjlabs/heroku-email-service:${env.BUILD_ID} storjlabs/heroku-email-service:${commit_id} storjlabs/heroku-email-service:latest"

    stage 'Deploy'

      echo 'Push to Repo'
      sh "./dockerfiles/deploy.staging.sh heroku-email-service storjlabs/heroku-email-service:${env.BUILD_ID}"

    stage 'Cleanup'

      echo 'prune and cleanup'
      sh """#!/bin/bash -e
        source '/var/lib/jenkins/.nvm/nvm.sh'
        rm node_modules -rf
      """

      /*
      mail body: 'project build successful',
        from: 'build@storj.io',
        replyTo: 'build@storj.io',
        subject: 'project build successful',
        to: "${env.CHANGE_AUTHOR_EMAIL}"
      */

  }

  catch (err) {
    currentBuild.result = "FAILURE"

    /*
    mail body: "project build error is here: ${env.BUILD_URL}" ,
      from: 'build@storj.io',
      replyTo: 'build@storj.io',
      subject: 'project build failed',
      to: "${env.CHANGE_AUTHOR_EMAIL}"

      throw err
    */
  }
}
