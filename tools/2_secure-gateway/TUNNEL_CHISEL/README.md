#https://github.com/jpillora/chisel



# Install Server Ubuntu

```bash
wget https://github.com/jpillora/chisel/releases/download/v1.7.6/chisel_1.7.6_linux_amd64.gz
gzip -d chisel_1.7.6_linux_amd64.gz
sudo mv chisel_1.7.6_linux_amd64 /usr/local/bin/chisel
sudo chmod +x /usr/local/bin/chisel
```


# Run Server
## Create Certs


```bash
sudo snap install core; sudo snap refresh core
remove certbot
sudo snap install --classic certbot


sudo certbot certonly --standalone

sudo cp /etc/letsencrypt/live/ns343373.ip-91-121-xxx.eu/fullchain.pem .
sudo cp /etc/letsencrypt/live/ns343373.ip-91-121-xxx.eu/privkey.pem .
```

## Start Server

```bash
chisel server reverse ----authfile="./users.json" --tls-cert="./fullchain.pem" --tls-key="./privkey.pem"

```

# Run Client OCP


```bash
oc apply -n default -f ./tools/2_secure-gateway/TUNNEL_CHISEL/clientRobotShop.yaml

oc apply -n default -f ./tools/2_secure-gateway/TUNNEL_CHISEL/clientSlack.yaml

```



# Test Mac

```bash
./chisel_1.7.6_darwin_arm64 client --auth="admin:P4ssw0rd" 94.121.172.228:8080 R:22000:localhost:22 
```



