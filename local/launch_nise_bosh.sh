#!/bin/bash -ex

# Set current ip to nats server
NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-`ip addr | grep 'inet .*global' | cut -f 6 -d ' ' | cut -f1 -d '/' | head -n 1`}

NISE_IP_ADDRESS=${NISE_IP_ADDRESS} ./common/launch_nise_bosh.sh

(
    cd nise_bosh
    bundle install
    # Old spec format
    sudo env PATH=$PATH bundle exec ./bin/nise-bosh -y ../cf-release ../manifests/deploy.yml micro -n ${NISE_IP_ADDRESS}
    # New spec format, keeping the  monit files installed in the previous run
    sudo env PATH=$PATH bundle exec ./bin/nise-bosh --keep-monit-files -y ../cf-release ../manifests/deploy.yml micro_ng -n ${NISE_IP_ADDRESS}
)
