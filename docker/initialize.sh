#!/usr/bin/env bash
set -ex

echo "Ensuring .env.development.local file exists"
touch .env.development.local

echo "Bringing down running containers"
docker-compose down --volumes --remove-orphans

echo "Building remaining containers"
docker-compose build

echo "Initializing databases"
docker-compose run --rm app bundle exec rake db:create db:migrate db:test:load db:seed

echo "Installing dnsmasq via homebrew"
brew list dnsmasq &>/dev/null || brew install dnsmasq

echo "Deleting old domain data"
sed -i '' '/^address=\/\.*contacts-importer\.test\//d' /usr/local/etc/dnsmasq.conf

echo "Appending domains"
cat ./docker/dnsmasq/dnsmasq.conf >> /usr/local/etc/dnsmasq.conf

echo "Setting up custom resolvers"
sudo mkdir -p /etc/resolver
sudo cp ./docker/dnsmasq/resolver/* /etc/resolver/

echo "Starting dnsmasq"
sudo brew services restart dnsmasq

echo "Done! You can run 'docker compose up' now"
