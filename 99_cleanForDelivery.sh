echo "***************************************************************************************************************************************************"
echo " ๐  Clean for GIT Push" 
echo "***************************************************************************************************************************************************"


echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "    ๐  Restoring vanilla config" 
echo "--------------------------------------------------------------------------------------------------------------------------------"
mkdir -p ./DO_NOT_DELIVER/OLD_CONFIGS/
cp ./00_config-secrets.sh "./DO_NOT_DELIVER/OLD_CONFIGS/00_config-secrets-$(date +"%y-%m-%d-%r").sh"
cp ./tools/0_global/00_config-secrets-vanilla.sh ./00_config-secrets.sh 

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "    ๐  Find File Copies" 
echo "--------------------------------------------------------------------------------------------------------------------------------"
find . -name '*copy*' -type f | grep -v DO_NOT_DELIVER


echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "    ๐  Deleting large and sensitive files" 
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "      ๐งป  Deleting DS_Store" 
find . -name '.DS_Store' -type f -delete
echo "      ๐งป  Deleting Certificate Files" 
find . -name 'cert.*' -type f -delete
echo "      ๐งป  Deleting Certificate Authority Files" 
find . -name 'ca.*' -type f -delete
echo "      ๐งป  Deleting TLS Secrets" 
find . -name 'openshift-tls-secret*' -type f -delete
echo "      ๐งป  Deleting JSON Log Files Kafka" 
find . -name '*.json' -type f -size +1000000k -delete
echo "      ๐งป  Deleting JSON Log Files Elastic" 
find . -name '*-logtrain.json' -type f -size +10000k -delete
echo "      ๐งป  Deleting Conflict Files" 
find . -name '*2021_Conflict*' -type f -delete



echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "    ๐  Remove Temp Files" 
echo "--------------------------------------------------------------------------------------------------------------------------------"
rm -f ./reset/tmp_connection.json
rm -f ./reset/test.json
rm -f ./demo/external-tls-secret.yaml
rm -f ./demo/iaf-system-backup.yaml
rm -f ./external-tls-secret.yaml
rm -f ./iaf-system-backup.yaml
rm -fr training/TRAINING_FILES/KAFKA/robot-shop/logs/__MACOSX

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "    ๐  Biggest files" 
echo "--------------------------------------------------------------------------------------------------------------------------------"
find . -type f -print0 | xargs -0 ls -la | awk '{print int($5/1000) " KB\t" $9}' | sort -n -r -k1| grep -v DO_NOT_DELIVER|grep -v .git| head -20

echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "    ๐  Check for Tokens and Keys" 
echo "--------------------------------------------------------------------------------------------------------------------------------"
echo "      ๐งป  Check for Webhooks" 
grep -rnw '.' -e 'NETCOOL_WEBHOOK_GENERIC=https:' | grep -v 'DO_NOT_DELIVER'
echo "      ๐งป  Check for Slack User Token" 
grep -rnw '.' -e 'xoxp' | grep -v 'DO_NOT_DELIVER' | grep -v 'xoxp-*'
echo "      ๐งป  Check for Slack Bot Token" 
grep -rnw '.' -e 'xoxb' | grep -v 'DO_NOT_DELIVER' | grep -v 'xoxb-*'

