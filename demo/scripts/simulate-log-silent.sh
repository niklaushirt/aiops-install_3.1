source ./tools/0_global/99_config-global.sh
get_kafkacat


for actFile in $(ls -1 $WORKING_DIR_LOGS | grep "json"); 
do 

#--------------------------------------------------------------------------------------------------------------------------------------------
#  Prepare the Log Data
#--------------------------------------------------------------------------------------------------------------------------------------------

    case $LOG_TYPE in
        elk) export DATE_FORMAT="+%Y-%m-%dT%H:%M:%S.000Z";;
        humio) export DATE_FORMAT="+%s000";;
        *) export DATE_FORMAT="+%s000";;
    esac

    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Create file and structure in /tmp
    #--------------------------------------------------------------------------------------------------------------------------------------------
    mkdir /tmp/training-logs/  >$log_output_path 2>&1  || true
    rm /tmp/training-logs/x* >$log_output_path 2>&1  || true
    cp $WORKING_DIR_LOGS/$actFile /tmp/training-logs/
    cd /tmp/training-logs/
    
    echo "...."

    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Update Timestamps
    #--------------------------------------------------------------------------------------------------------------------------------------------
    while IFS= read -r line
    do
        # Get timestamp in ELK format
        export my_timestamp=$(date $DATE_FORMAT)
        # Replace in line
        line=${line/MY_TIMESTAMP/$my_timestamp}
        # Write line to temp file
        echo $line >> /tmp/timestampedErrorLogs.json
    done < "$actFile"

    echo "...."

    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Split the files in 1500 line chunks for kafkacat
    #--------------------------------------------------------------------------------------------------------------------------------------------
    split -l 1500 /tmp/timestampedErrorLogs.json
    export NUM_FILES=$(ls | wc -l)
    rm $actFile
    rm /tmp/timestampedErrorLogs.json
    cd -  >$log_output_path 2>&1  || true

    echo "...."



    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Get the cert for kafkacat
    #--------------------------------------------------------------------------------------------------------------------------------------------
    oc project $WAIOPS_NAMESPACE >$log_output_path 2>&1  || true

    oc extract secret/strimzi-cluster-cluster-ca-cert -n $WAIOPS_NAMESPACE --keys=ca.crt >$log_output_path 2>&1  || true

    echo "...."



    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Inject the logs
    #--------------------------------------------------------------------------------------------------------------------------------------------
    ACT_COUNT=0
    for FILE in /tmp/training-logs/*; do 
        if [[ $FILE =~ "x"  ]]; then
            ACT_COUNT=`expr $ACT_COUNT + 1`
            ${KAFKACAT_EXE} -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$KAFKA_PASSWORD -b $KAFKA_BROKER -P -t $LOGS_TOPIC -l $FILE   >$log_output_path 2>&1  || true
            echo "...."
        fi
    done
done

#--------------------------------------------------------------------------------------------------------------------------------------------
#  Clean up
#--------------------------------------------------------------------------------------------------------------------------------------------
rm /tmp/training-logs/x*
rm ./ca.crt