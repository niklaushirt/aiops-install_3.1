read -p "Are you really, really, REALLY sure you want to shut down the Ratings Service? [y,N] " DO_COMM
  if [[ $DO_COMM == "y" ||  $DO_COMM == "Y" ]]; then
    oc scale --replicas=0  deployment ratings-v1 -n bookinfo
  else
    echo "${RED}Aborted${NC}"
  fi


