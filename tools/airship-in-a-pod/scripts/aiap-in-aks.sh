#!/bin/bash

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ex

: LOCATION=${LOCATION:=westus}
: GROUP=${GROUP:=aiap-test}
: CLUSTER=${CLUSTER:=aiap}
: CLEANUP_GROUP=${CLEANUP_GROUP:=false}
: TIMEOUT=${TIMEOUT:=7200}
: LOG_DIR=${LOG_DIR:="tools/airship-in-a-pod/logs"}
: AIAP_POD=${AIAP_POD:="tools/airship-in-a-pod/examples/airshipctl"}

az account show
if $(az group exists --name ${GROUP}) && ${CLEANUP_GROUP}; then
    echo "group ${GROUP} already exists and \$CLEANUP_GROUP is false, exiting"
    exit 1
fi

az group create --name ${GROUP} -l ${LOCATION}
az aks create --name ${CLUSTER} --resource-group ${GROUP} --node-count 1 --node-vm-size Standard_D8s_v3
az aks get-credentials --name ${CLUSTER} --resource-group ${GROUP} --overwrite-existing
kubectl apply -k ${AIAP_POD}

set +x
echo "waiting up to $TIMEOUT seconds for airship-in-a-pod to complete..."
end=$(($(date +%s) + $TIMEOUT))
echo "* waiting up to 10m for containers to become ready..."
kubectl wait pod airship-in-a-pod --for condition=ContainersReady --timeout 10m
while true; do
    last_status=$(kubectl logs airship-in-a-pod -c status-checker --tail 1)
    if [ $(grep -o "SUCCESS" <<<$last_status | wc -l) = 3 ] ; then
        echo -e "\nairship-in-a-pod completed successfully."
        break
    elif grep -q "FAILED" <<<$last_status ; then
        echo -e "\nAirship-in-a-pod completed with FAILURE: $last_status"
        break
    else
        now=$(date +%s)
        if [ $now -gt $end ]; then
            echo -e "\nAirship-in-a-Pod did not complete before TIMEOUT."
            break
        fi
        echo -n .
        sleep 60
    fi
done
set -x +e

echo "extracting logs to ${LOG_DIR}..."
mkdir -p ${LOG_DIR}
rm -f ${LOG_DIR}/aiap-*\.log
for c in $(kubectl get pod -o jsonpath="{.spec.containers[*].name}" airship-in-a-pod); do
    kubectl logs airship-in-a-pod -c $c > ${LOG_DIR}/aiap-$c.log
done

if ${CLEANUP_GROUP}; then
    echo "deleting resource group ${GROUP}..."
    az group delete --name ${GROUP} -y
    kubectl config delete-user "clusterUser_${GROUP}_${CLUSTER}"
    kubectl config delete-cluster "${CLUSTER}"
    kubectl config delete-context "${CLUSTER}"
fi
