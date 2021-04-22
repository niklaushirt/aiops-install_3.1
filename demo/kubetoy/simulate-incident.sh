  echo "Simulating Bookinfo Ratings outage"



input="./kubetoy/error_event.json"

while true 
do
  while IFS= read -r line
  do
    export my_timestamp=$(date +%s)000
    echo "Injecting Event at: $my_timestamp"

    curl --insecure -X "POST" "$NETCOOL_WEBHOOK_HUMIO" \
      -H 'Content-Type: application/json; charset=utf-8' \
      -d $"${line}"
    echo "----"
  done < "$input"
done
echo "Done"


