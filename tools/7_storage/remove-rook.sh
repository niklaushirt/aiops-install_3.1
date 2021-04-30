  oc delete -f ./tools/7_storage/yaml/crds.yaml
  oc delete -f ./tools/7_storage/yaml/common.yaml
  oc delete -f ./tools/7_storage/yaml/operator-openshift.yaml
  oc delete -f ./tools/7_storage/yaml/cluster.yaml
  oc delete -f ./tools/7_storage/yaml/filesystem.yaml
  oc delete -f ./tools/7_storage/yaml/storageclass-fs.yaml
  #oc delete -f ./tools/7_storage/yaml/storageclass-block.yaml
  oc patch storageclass rook-cephfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
