echo $SSH_KEY > /root/.ssh/authorized_keys
service ssh restart
echo $SSH_KEY > /root/.ssh/authorized_keys
top
while true; do sleep 30; done;