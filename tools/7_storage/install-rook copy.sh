# https://github.ibm.com/velox/e2e-automation/wiki/OCP-on-Fyre


 

git clone https://github.com/rook/rook.git -b v1.5.10

cd tools/7_storage/rook
cd cluster/examples/kubernetes/ceph
kubectl create -f ./tools/7_storage/yaml/common.yaml
kubectl create -f ./tools/7_storage/yaml/operator-openshift.yaml

# verify the rook-ceph-operator is in the `Running` state before proceeding
kubectl -n rook-ceph get pod

sed -i 's/useAllDevices: true/useAllDevices: false/g' ./tools/7_storage/yaml/cluster.yaml
sed -i 's/useAllNodes: true/useAllNodes: false/g' ./tools/7_storage/yaml/cluster.yaml


oc describe no -l node-role.kubernetes.io/worker | grep hostname



nodes:
    - name: "<hostname for worker node>"
      devices: # specific devices to use for storage can be specified for each node
      - name: "vdb"
      - name: "vdc"



oc create -f ./tools/7_storage/yaml/cluster.yaml
oc create -f ./tools/7_storage/yaml/storageclass.yaml
oc create -f ./tools/7_storage/yaml/torageclass.yaml

