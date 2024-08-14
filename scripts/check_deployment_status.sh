#!/bin/bash

CLUSTER_NAME=$1
SERVICE_NAME=$2


#
STATUS=$(aws ecs describe-services --services $SERVICE_NAME --cluster $CLUSTER_NAME | jq -rc '.services[0].deployments[0].rolloutState' )
##echo "${STATUS}"
##if [[ $STATUS == "COMPLETED" ]]; then
##  echo "done"
##fi
#exit 0

while [[ $STATUS == "IN_PROGRESS" ]]; do
STATUS=$(aws ecs describe-services --services $SERVICE_NAME --cluster $CLUSTER_NAME | jq -rc '.services[0].deployments[0].rolloutState' )
echo "${STATUS} << WAITING FOR RESTART STATUS TO REACH COMPLETED"
sleep 20
done

if [[ $STATUS == "COMPLETED"  ]]; then
  echo "SERVICE RESTART HAS COMPLETED SUCCESSFULLY"
  exit 0
fi



echo 'SERVICE RESTART HAS FAILED'
exit 1
