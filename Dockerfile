FROM php:7.3-fpm-alpine3.12 AS builder

RUN \
    adduser -h /app -D -u 1000 app && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app
USER app

RUN \    
    wget https://github.com/jikan-me/jikan-rest/archive/master.tar.gz && \
    tar -xvf master.tar.gz && rm -f master.tar.gz && \
    cd jikan-rest-master && \
    mv .env.dist .env && \
    sed -r 's%^REDIS_HOST.*%REDIS_HOST=redis%g' -i .env && \
    composer install --no-interaction --prefer-dist --optimize-autoloader && \
    php artisan key:generate

FROM php:7.3-fpm-alpine3.12 AS runtime

COPY --from=builder /app/jikan-rest-master /app

RUN \ 
    wget \
        https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 \
        -O /usr/bin/dumb-init && \
    chmod 755 /usr/bin/dumb-init && \
    apk add nginx && \
    install -d -o nginx -g nginx -m 0770 /run/nginx && \
    adduser -h /app -D -u 1000 app && \
    rm -rf /usr/local/etc/php-fpm.d/*

COPY configs/php-fpm.d/ /usr/local/etc/php-fpm.d/
COPY configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY scripts/entrypoint /entrypoint

WORKDIR /app

EXPOSE 80/tcp

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoint" ]
CMD []
