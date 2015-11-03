#!/bin/bash


if [ -f /.rabbitmq_setup ]; then
	echo "RabbitMQ already setup!"
	exit 0
fi


RABBITMQ_PASS=${RABBITMQ_PASS:-$(pwgen -s 12 1)}
RABBITMQ_USER=${RABBITMQ_USER:-"admin"}
_word=$( [ ${RABBITMQ_PASS} ] && echo "preset" || echo "random" )
echo "=> Securing RabbitMQ with a ${_word} password"

RABBITMQ_PORT=${RABBITMQ_PORT:-5672}

INET_DIST_LISTEN_MIN=${INET_DIST_LISTEN_MIN:-55950}
INET_DIST_LISTEN_MAX=${INET_DIST_LISTEN_MAX:-55954}

# For reference: https://www.rabbitmq.com/configure.html
cat > /etc/rabbitmq/rabbitmq.config <<EOF
[
	{rabbit, [{default_user, <<"$RABBITMQ_USER">>},
                  {default_pass, <<"$RABBITMQ_PASS">>},
                  {default_permissions, [<<".*">>, <<".*">>, <<".*">>]},
                  {tcp_listeners, [${RABBITMQ_PORT}]},
                  {reverse_dns_lookups, true},
                  {cluster_partition_handling, pause_minority},
                  {log_levels, [
                    {connection, info},
                    {mirroring, info},
                    {federation, info}
                  ]},
                  {loopback_users, []}
        ]},
        {kernel, [{inet_dist_listen_min, $INET_DIST_LISTEN_MIN},
                  {inet_dist_listen_max, $INET_DIST_LISTEN_MAX}
        ]}
].
EOF



echo "=> Done!"
touch /.rabbitmq_setup

echo "========================================================================"
echo "You can now connect to this RabbitMQ server using, for example:"
echo ""

if [ ${_word} == "random" ]; then
    echo "    curl --user $RABBITMQ_USER:$RABBITMQ_PASS http://<host>:<port>/api/vhosts"
    echo ""
    echo "Please remember to change the above password as soon as possible!"
else
    echo "    curl --user $RABBITMQ_USER:<RABBITMQ_PASS> http://<host>:<port>/api/vhosts"
    echo ""
fi

echo "========================================================================"