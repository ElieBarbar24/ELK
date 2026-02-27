docker compose -f docker-compose.yml up --abort-on-container-exit
sudo chown -R 1000:1000 certs
sudo chmod -R 750 certs

Settings:
xpack.encryptedSavedObjects.encryptionKey: f85827cd00f865b8f4220e1b1314f73d
- xpack.reporting.encryptionKey: 3fa6c9c40f15f0b76642b5a789f4d756
- xpack.security.encryptionKey: 782f85da16c66d499b47dc1afded0441