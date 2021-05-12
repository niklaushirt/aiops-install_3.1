

source ./01_config.sh

banner 

echo "Pushing QOTD to GitHub"



if [[ $NETCOOL_WEBHOOK_GENERIC == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_GENERIC == "" ]];
then
      echo "Skipping Events injection"
else
  while true
  do
      input="./qotd/events_qotd.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000
        echo "Injecting Event at: $my_timestamp"
line=${line/MY_TIMESTAMP/$my_timestamp}
#$(echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp/")
echo $line
        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_GENERIC" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}"
        echo "."
      done < "$input"
  done
      sleep 2
fi





echo "Git Push.... Done...."


