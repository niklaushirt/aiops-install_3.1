
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# Init Code
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
# ---------------------------------------------------------------------------------------------------------------------------------------------------"
        # fix sed issue on mac
        OS=$(uname -s | tr '[:upper:]' '[:lower:]')
        SED="sed"
        if [ "${OS}" == "darwin" ]; then
            SED="gsed"
            if [ ! -x "$(command -v ${SED})"  ]; then
            __output "This script requires $SED, but it was not found.  Perform \"brew install gnu-sed\" and try again."
            exit
            fi
        fi

cat ./tools/8_training/DUMP_SNOW/snowchangerequest.json > /tmp/snowchangerequest1.json


cat /tmp/snowchangerequest1.json | ${SED} -e 's/,"raw_data":{.*}}}/}}/' > /tmp/snowchangerequest2.json

cat /tmp/snowchangerequest2.json | ${SED} -e 's/Unsuccessful/unsuccessful/' > /tmp/snowchangerequest3.json
cat /tmp/snowchangerequest3.json | ${SED} -e 's/Successful/successful/' > /tmp/snowchangerequest4.json

cat /tmp/snowchangerequest3.json  > ./tools/8_training/INDEXES_SNOW/snowchangerequest.json

#./tools/8_training/INDEXES_SNOW/snowchangerequest.json


