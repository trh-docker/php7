FROM quay.io/spivegin/caddy_only AS caddy-source

FROM quay.io/spivegin/tlmbasedebian
RUN mkdir -p /opt/bin /opt/caddy /run/php/
COPY --from=caddy-source /opt/bin/caddy /opt/bin/
ADD files/Caddy/Caddyfile /opt/caddy/
WORKDIR /opt/tlm/html
# Installing Curl and OpenSSL
RUN apt-get update && apt-get install -y curl openssl gnupg wget gzip git &&\
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
# Setting up Caddy Server, AFZ Cert and installing dumb-init
ENV DINIT=1.2.2

ADD https://raw.githubusercontent.com/adbegon/pub/master/AdfreeZoneSSL.crt /usr/local/share/ca-certificates/
ADD https://github.com/Yelp/dumb-init/releases/download/v${DINIT}/dumb-init_${DINIT}_amd64.deb /tmp/dumb-init_amd64.deb

RUN update-ca-certificates --verbose &&\
    chmod +x /opt/bin/caddy &&\
    ln -s /opt/bin/caddy /bin/caddy &&\
    dpkg -i /tmp/dumb-init_amd64.deb && \
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
ADD files/php/ /etc/php/7.0/fpm/pool.d/
RUN apt-get update && apt-get install -y \
    php7.0 \
    php7.0.cgi \
    php7.0-dom \
    php7.0-ctype \
    php7.0-curl \
    php7.0-fpm \
    php7.0-gd \
    php7.0-intl \
    php7.0-json \
    php7.0-mbstring \
    php7.0-mcrypt \
    php7.0-mysqli \
    php7.0-mysqlnd \
    php7.0-opcache \
    php7.0-pdo \
    php7.0-posix \
    php7.0-xml \
    php7.0-iconv \
    php7.0-imagick \
    php7.0-xdebug \
    php-pear \
    php7.0-phar && \
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*