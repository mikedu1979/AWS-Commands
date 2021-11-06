call ../az-env.cmd
call ../az-env.staging.cmd
call node %~dp0/azure-resources/angular-update/update.js --environment-path %1 --users-stack %2 --user-pool %3 --user-pool-client %4 --api-gateway-stack %5 --api-gateway %6