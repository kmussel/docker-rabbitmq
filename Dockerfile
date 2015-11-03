# RabbitMQ
#
# VERSION               0.0.1

FROM      ubuntu:14.04
MAINTAINER Kevin Musselman "kmussel@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

# Add files.


ADD rabbitmq-signing-key-public.asc /tmp/rabbitmq-signing-key-public.asc
RUN apt-key add /tmp/rabbitmq-signing-key-public.asc

RUN echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
RUN apt-get -qq update > /dev/null
RUN apt-get -qq -y install rabbitmq-server > /dev/null
RUN /usr/sbin/rabbitmq-plugins enable rabbitmq_management


# Add scripts
RUN mkdir -p /opt/rabbitmq/bin/
ADD scripts/setup_rabbitmq.sh /opt/rabbitmq/bin/setup_rabbitmq.sh
ADD run.sh /opt/rabbitmq/bin/run.sh

## Setup custom rabbitmq scripts to be executable.
RUN chmod +x /opt/rabbitmq/bin/*.sh


RUN echo "ERLANGCOOKIE" > /var/lib/rabbitmq/.erlang.cookie
RUN chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie

# Define mount points.
VOLUME ["/data/log", "/data/kmussel"]

# Define working directory.
WORKDIR /data

EXPOSE 5672 15672 4369

# erlang communication ports
EXPOSE 55950 55951 55952 55953 55954

CMD /opt/rabbitmq/bin/run.sh