docker compose -f docker-compose.yml up --abort-on-container-exit
sudo chown -R 1000:1000 certs
sudo chmod -R 750 certs

docker exec -it kibana /usr/share/kibana/bin/kibana-encryption-keys generate