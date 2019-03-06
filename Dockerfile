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
ENV DINIT=1.2.2 \
    DOMAIN=0.0.0.0 \
    PORT=80 \
    PHP_VERSION="7.0"

ADD https://raw.githubusercontent.com/adbegon/pub/master/AdfreeZoneSSL.crt /usr/local/share/ca-certificates/
ADD https://github.com/Yelp/dumb-init/releases/download/v${DINIT}/dumb-init_${DINIT}_amd64.deb /tmp/dumb-init_amd64.deb

RUN update-ca-certificates --verbose &&\
    chmod +x /opt/bin/caddy &&\
    ln -s /opt/bin/caddy /bin/caddy &&\
    dpkg -i /tmp/dumb-init_amd64.deb && \
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
ADD files/php/ /etc/php/${PHP_VERSION}/fpm/pool.d/
RUN apt-get update && apt-get install -y \
    php${PHP_VERSION} \
    php${PHP_VERSION}.cgi \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-ctype \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mcrypt \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-mysqlnd \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-posix \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-iconv \
    php${PHP_VERSION}-imagick \
    php${PHP_VERSION}-xdebug \
    php-pear \
    php${PHP_VERSION}-phar && \
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

EXPOSE 80

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/opt/bin/entry.sh"]