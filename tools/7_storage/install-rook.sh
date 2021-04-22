
  oc create -f ./tools/7_storage/yaml/crds.yaml
  oc create -f ./tools/7_storage/yaml/common.yaml
  oc create -f ./tools/7_storage/yaml/operator-openshift.yaml
  oc create -f ./tools/7_storage/yaml/cluster.yaml
  oc create -f ./tools/7_storage/yaml/filesystem.yaml
  oc create -f ./tools/7_storage/yaml/storageclass.yaml
  oc create -f ./tools/7_storage/yaml/storageclass-test.yaml
  oc patch storageclass rook-cephfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'



