export NETCOOL_WEBHOOK_TEST=https://netcool-evtmanager.dteroks-270003bu3k-iztoq-4b4a324f027aea19c5cbc0c3275c4656-0000.eu-gb.containers.appdomain.cloud/norml/webhook/webhookincomming/cfd95b7e-3bc7-4006-a4a8-a73a79c71255/c26ee408-bf04-450a-be9e-a5ba21756a2b/bAF1c85UTUqG8N4CqA0aGfYrmMoBkhNl0AqNPe41JVM


echo "Simulating Bookinfo Events"

echo "Quit with Ctrl-Z"


if [[ $NETCOOL_WEBHOOK_TEST == "not_configured" ]] || [[ $NETCOOL_WEBHOOK_TEST == "" ]];
then
      echo "Skipping Events injection"
else
  while true
  do
      echo "Inject Events"
      input="./robotshop/events_robotshop.json"
      while IFS= read -r line
      do
        export my_timestamp=$(date +%s)000
        echo "Injecting Event at: $my_timestamp"
line=${line/MY_TIMESTAMP/$my_timestamp}
#$(echo ${line} | gsed "s/MY_TIMESTAMP/$my_timestamp/")
echo $line
        curl --insecure -X "POST" "$NETCOOL_WEBHOOK_TEST" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -H 'Cookie: d291eb4934d76f7f45764b830cdb2d63=90c3dffd13019b5bae8fd5a840216896' \
          -d $"${line}"
        echo "----"
      done < "$input"
  done
      echo "Done"
      echo ""
      echo ""
      echo ""
      echo ""
      echo ""
      sleep 2
fi





echo "Bookinfo Ratings outage simulation.... Done...."


