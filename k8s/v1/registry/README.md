## Create registry account
```sh
sudo apt install apache2-utils

cd auth 
htpasswd -Bc registry.password admin
cd ..
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./nginx/ssl/nginx.key -out ./nginx/ssl/nginx.crt

openssl req -newkey rsa:4096 -nodes -sha256 -keyout ./nginx/ssl/nginx.key -x509 -days 365 -out ./nginx/ssl/nginx.crt
docker-compose up

```

# Client
```
cat /etc/docker/daemon.json
{
     "bip": "172.17.0.5/16",	                            #already exists 
	"insecure-registries" : ["10.61.169.83:5000"],      #CHANGE
}
```