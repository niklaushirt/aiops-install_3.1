

source ./00_config-secrets.sh


  export SLACK_CHANNEL=$SLACK_PROACTIVE
  python3 ./slack-cleaner-no-interaction.py


  export SLACK_CHANNEL=$SLACK_REACTIVE
  python3 ./slack-cleaner-no-interaction.py


  export SLACK_CHANNEL=$SLACK_ROBOT
  python3 ./slack-cleaner-no-interaction.py


