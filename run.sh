#!/bin/bash

set -m

# make rabbit own its own files
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq

RABBITMQ_VHOST=${RABBITMQ_VHOST:-"/"}
RABBITMQ_USER=${RABBITMQ_USER:-"admin"}

echo "rabbitmqctl add_user $RABBITMQ_USER $RABBITMQ_PASS $RABBITMQ_VHOST" # > /var/log/rabbitmq/add-user-command.out
# Setup rabbitmq

# if [ ! -f /.rabbitmq_setup ]; then
	/opt/rabbitmq/bin/setup_rabbitmq.sh
	/usr/sbin/rabbitmq-server & sleep 10
	rabbitmqctl add_vhost $RABBITMQ_VHOST
	rabbitmqctl set_permissions -p $RABBITMQ_VHOST $RABBITMQ_USER ".*" ".*" ".*" > /var/log/rabbitmq/set-permissions.out
	rabbitmqctl stop & sleep 10

# fi

/usr/sbin/rabbitmq-server


# rabbitmqctl stop_app
# rabbitmqctl start_app
# > /var/log/rabbitmq/add-vhost.out

# if [ -z "$CLUSTER_WITH" ] ; then
#     /usr/sbin/rabbitmq-server
# else
#     if [ -f /.CLUSTERED ] ; then
#     /usr/sbin/rabbitmq-server
#     else
#         touch /.CLUSTERED
#         /usr/sbin/rabbitmq-server &
#         sleep 10
#         rabbitmqctl stop_app
#         rabbitmqctl join_cluster rabbit@$CLUSTER_WITH
#         rabbitmqctl start_app
#         fg
#     fi
# fi




