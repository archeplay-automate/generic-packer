#!/bin/bash
set +x
sudo apt-get install jq -y
apt-get install docker-ce docker-ce-cli containerd.io -y
sudo usermod -a -G docker ec2-user
sudo systemctl  start docker
sudo systemctl status docker
sudo systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sudo apt-get install git -y
sudo git clone https://github.com/mohanraz81/archeplay-ecomm-demo.git
REGION=`curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`
sudo sed -i "s/REGIONNAME/$REGION/g" archeplay-ecomm-demo/product/docker-compose.yaml
sudo sed -i "s/TABLENAME/$TABLENAME/g" archeplay-ecomm-demo/product/docker-compose.yaml
sudo cp archeplay-ecomm-demo/product/product.service /etc/systemd/system/product.service
sudo systemctl daemon-reload
sudo systemctl enable product.service
sudo systemctl start product.service
sleep 120
sudo docker ps -a