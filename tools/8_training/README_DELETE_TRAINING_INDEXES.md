# Delete Trained Log Model


## Delete Indices

```bash
oc project aiops
oc exec -it $(oc get po |grep model-train-console|awk '{print$1}') bash
```
oc get po |grep aimanager-aio-controller
## Delete Incident Models


```bash

# Get all indices for Model
curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep incident

# Delete all indices for Model
indexes=$(curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep incident | awk '{print $3;}')
echo $indexes
```


```bash
# Then delete the indexes

for item in $indexes
do
        echo "curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$item"
        curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$item
done




## Delete Log Anomaly Models

curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep 1000 | grep -v event | grep -v incident | awk '{print $3;}'


# Delete all indices for Model
indexes=$(curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep 1000 | grep -v event | grep -v incident | awk '{print $3;}')
echo $indexes
```


```bash
# Then delete the indexes

for item in $indexes
do
        echo "curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$item"
        curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$item
done












```bash

# Get all indices for Model
curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep anomaly

# Delete all indices for Model
indexes=$(curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep anomaly | awk '{print $3;}')
echo $indexes
```


```bash
# Then delete the indexes

for item in $indexes
do
        echo "curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$item"
        curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$item
done


```




































# DELETE LOG MODEL INDICES

```
curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep $appgroupid-$appid | awk '{print $3;}'




curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-embedding_pca_fe         
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-anomaly_group_id         
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-templates                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-applications             
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-pca_fe                   
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-training_count_vectors   
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-pca_model                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-$version-embedding_pca_model      
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$appgroupid-$appid-log_models_latest




indexes=$(curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure | grep $appgroupid-$appid | awk '{print $3;}')
echo $indexes

for item in $indexes
do
        echo "curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$item"
        curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/$item
done


```



## Get all indices

```bash
curl -u $ES_USERNAME:$ES_PASSWORD -XGET https://$ES_ENDPOINT/_cat/indices  --insecure  | awk '{print $3;}'
```





aws s3 rm s3://event-group/ --recursive
aws s3 rm s3://event-grouping-service/ --recursive
aws s3 rm s3://event-ingest/ --recursive
aws s3 rm s3://log-anomaly/ --recursive
aws s3 rm s3://log-ingest/ --recursive
aws s3 rm s3://log-model/ --recursive
aws s3 rm s3://similar-incident-service/ --recursive





curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-1-templates
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210313-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-event_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210301-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-embedding_pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-pagerduty_mapping_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210310-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-1-applications
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-log_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-1-applications
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-1-embedding_pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/normalized-incidents-demoapps-robotshop
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-log_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-1-pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-pagerduty_mapping_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/normalized-incidents-7tgnhsi8-jkgtyuzt
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-templates
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-1-applications
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-event_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-1-pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-event_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-incident_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-anomaly_group_id
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210308-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-log_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-20210318-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-incident_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-1-anomaly_group_id
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-20210318-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-1-embedding_pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-1-training_count_vectors
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-1-pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-1-templates
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/normalized-incidents-ql32h8s4-rbbnyzy0
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/normalized-incidents-pzt8qseh-vupmhihp
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-applications
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-training_count_vectors
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-embedding_pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-1-embedding_pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210318-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-embedding_pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210312-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-1-training_count_vectors
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210315-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-pagerduty_mapping_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210309-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-1-embedding_pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-20210319-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-1-embedding_pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-incident_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-1-pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-pagerduty_mapping_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-1-embedding_pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-20210317-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-event_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-1-training_count_vectors
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-embedding_pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-templates
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/normalized-incidents-7tgnhsi8-bfzdis1o
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210317-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-pagerduty_mapping_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-incident_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-log_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-training_count_vectors
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-1-pca_fe
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-20210318-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-anomaly_group_id
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-applications
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-1-templates
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-20210317-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-log_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210311-logtrain
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-1-anomaly_group_id
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-incident_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-event_models_latest
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-pca_model
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-1-pca_model




curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-20210317-logtrain                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-embedding_pca_fe               
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-1-embedding_pca_model            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-embedding_pca_model            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-1-training_count_vectors         
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-pagerduty_mapping_models_latest 
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-1-embedding_pca_model           
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-incident_models_latest           
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-pagerduty_mapping_models_latest  
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-20210317-logtrain                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-1-embedding_pca_fe               
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-event_models_latest              
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-1-training_count_vectors        
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-pca_fe                         
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-embedding_pca_model            
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-templates                      
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/normalized-incidents-7tgnhsi8-bfzdis1o             
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210317-logtrain                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-pca_fe                         
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-pagerduty_mapping_models_latest  
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-incident_models_latest           
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-log_models_latest                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-training_count_vectors         
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-20210318-logtrain                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-1-pca_fe                        
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-1-templates                      
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-anomaly_group_id               
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-1-applications                   
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-jkgtyuzt-20210317-logtrain                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-log_models_latest                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-20210311-logtrain                
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/pzt8qseh-vupmhihp-1-anomaly_group_id               
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/demoapps-robotshop-incident_models_latest          
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-event_models_latest              
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/7tgnhsi8-bfzdis1o-1-pca_model                      
curl -u $ES_USERNAME:$ES_PASSWORD --insecure  -XDELETE https://$ES_ENDPOINT/ql32h8s4-rbbnyzy0-1-pca_model                      