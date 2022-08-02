FROM ubuntu:bionic

LABEL maintainer="Marcin Domański <marcin@kabturek.info>" \
     description="monitor.sh script"
		
RUN set -x && \
    apt-get update && \
    apt-get install -y  --no-install-recommends \
        bash \
        bc \
        bluez \
        bluez-hcidump \
        ca-certificates \
        curl \
        git \
	wget \
	gnupg \
        xxd 
	
RUN wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key && \
    apt-key add mosquitto-repo.gpg.key && \
    cd /etc/apt/sources.list.d/ && \
    wget http://repo.mosquitto.org/debian/mosquitto-buster.list && \
    apt-cache search mosquitto \
    apt-get install \
	libmosquitto-dev \
	mosquitto \
	mosquitto-clients \
	libmosquitto1 

RUN mkdir /monitor && \
    git clone https://github.com/andrewjfreyer/monitor.git /monitor

VOLUME ["/monitor", "/config"]
# Set up the entry point script and default command
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
WORKDIR /monitor
CMD ["/bin/bash", "monitor.sh", "-D", "/config"]
