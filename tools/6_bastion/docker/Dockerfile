FROM ubuntu:20.10

RUN apt-get update && apt-get install nano 
RUN apt-get install -y openssh-server
RUN wget https://github.com/openshift/okd/releases/download/4.6.0-0.okd-2021-01-23-132511/openshift-client-linux-4.6.0-0.okd-2021-01-23-132511.tar.gz && tar xfvz openshift-client-linux-4.6.0-0.okd-2021-01-23-132511.tar.gz && mv oc /usr/local/bin && mv oc /usr/local/bin/ && rm openshift-client-linux-4.6.0-0.okd-2021-01-23-132511.tar.gz

RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh/
RUN echo $SSH_KEY > /root/.ssh/authorized_keys
RUN touch /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

EXPOSE 22

COPY ssh-startup.sh /root/ssh-startup.sh
RUN chmod +x /root/ssh-startup.sh

ENTRYPOINT /root/ssh-startup.sh
