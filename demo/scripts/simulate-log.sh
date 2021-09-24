#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# DO NOT MODIFY BELOW
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

source ./tools/0_global/99_config-global.sh
get_kafkacat

for actFile in $(ls -1 $WORKING_DIR_LOGS | grep "json"); 
do 

#--------------------------------------------------------------------------------------------------------------------------------------------
#  Prepare the Log Data
#--------------------------------------------------------------------------------------------------------------------------------------------

    echo "***************************************************************************************************************************************************"
    echo "  🛠️  Preparing Data for file $actFile"
    echo "***************************************************************************************************************************************************"

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

    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Update Timestamps
    #--------------------------------------------------------------------------------------------------------------------------------------------
    echo "    🔨 Updating Timestamps (this can take several minutes)"
    echo "" > /tmp/timestampedErrorLogs.json
    while IFS= read -r line
    do
        # Get timestamp in ELK format
        export my_timestamp=$(date $DATE_FORMAT)
        # Replace in line
        line=${line/MY_TIMESTAMP/$my_timestamp}
        # Write line to temp file
        echo $line >> /tmp/timestampedErrorLogs.json
    done < "$actFile"
    echo "      ✅ OK"

    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Split the files in 1500 line chunks for kafkacat
    #--------------------------------------------------------------------------------------------------------------------------------------------
    echo "    🔨 Splitting"
    split -l 1500 /tmp/timestampedErrorLogs.json
    export NUM_FILES=$(ls | wc -l)
    rm $actFile
    rm /tmp/timestampedErrorLogs.json
    cd -  >$log_output_path 2>&1  || true
    echo "      ✅ OK"



    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Get the cert for kafkacat
    #--------------------------------------------------------------------------------------------------------------------------------------------
    oc project $WAIOPS_NAMESPACE >$log_output_path 2>&1  || true

    echo "***************************************************************************************************************************************************"
    echo "🥇 Getting Certs"
    echo "***************************************************************************************************************************************************"
    oc extract secret/strimzi-cluster-cluster-ca-cert -n $WAIOPS_NAMESPACE --keys=ca.crt >$log_output_path 2>&1  || true
    echo "      ✅ OK"



    #--------------------------------------------------------------------------------------------------------------------------------------------
    #  Inject the logs
    #--------------------------------------------------------------------------------------------------------------------------------------------
    echo "***************************************************************************************************************************************************"
    echo "🌏  Injecting Logs from File: ${actFile}" 
    echo "     Quit with Ctrl-Z"
    echo "***************************************************************************************************************************************************"
    ACT_COUNT=0
    for FILE in /tmp/training-logs/*; do 
        if [[ $FILE =~ "x"  ]]; then
            ACT_COUNT=`expr $ACT_COUNT + 1`
            echo "Injecting file ($ACT_COUNT/$(($NUM_FILES-1))) - $FILE"
            echo "            ${KAFKACAT_EXE} -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$KAFKA_PASSWORD -b $KAFKA_BROKER -P -t $LOGS_TOPIC -l $FILE"
            ${KAFKACAT_EXE} -v -X security.protocol=SSL -X ssl.ca.location=./ca.crt -X sasl.mechanisms=SCRAM-SHA-512  -X sasl.username=token -X sasl.password=$KAFKA_PASSWORD -b $KAFKA_BROKER -P -t $LOGS_TOPIC -l $FILE
            echo "      ✅ OK"
        fi
    done
done

#--------------------------------------------------------------------------------------------------------------------------------------------
#  Clean up
#--------------------------------------------------------------------------------------------------------------------------------------------
#rm /tmp/training-logs/x*
#rm ./ca.crt

echo ""
echo ""
echo ""
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
echo ""
echo " 🚀  CP4WAIOPS Log Simulation for $APP_NAME"
echo " ✅  Done..... "
echo ""
echo "***************************************************************************************************************************************************"
echo "***************************************************************************************************************************************************"
