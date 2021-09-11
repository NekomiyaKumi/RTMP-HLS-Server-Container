ARG ALPINE_VERSION=3.14.2
LABEL maintainer="Orville Q. Song<orville@anislet.dev>"

FROM alpine:${ALPINE_VERSION}

RUN apk update \
    && apk --no-cache add \
        ca-certificates \
        openssl \
        unzip \
        nginx \
        nginx-mod-rtmp \
    && mkdir /etc/nginx/conf.d \
    && wget https://github.com/Niek/obs-web/archive/refs/heads/gh-pages.zip \
    && unzip gh-pages.zip -d /var/www/ \
    && rm gh-pages.zip \
    && rm /etc/nginx/http.d/default.conf \
    && mv /var/www/obs-web-gh-pages/ /var/www/rtmp/ \
    && apk --no-cache del unzip \
    && sed -i 's/\#include \/etc\/nginx\/conf.d\/\*.conf\;/include \/etc\/nginx\/conf.d\/\*.conf\;/g' /etc/nginx/nginx.conf

COPY conf/rtmp.conf /etc/nginx/conf.d/rtmp.conf
COPY conf/hls.conf /etc/nginx/http.d/hls.conf
COPY assets/stat.xsl /var/www/rtmp/stat.xsl

EXPOSE 1935
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]