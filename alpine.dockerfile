FROM alpine:3.15.4

CMD ["/bin/sh"]

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN sed -i"" -e "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

RUN apk -U upgrade
RUN apk add --no-cache coreutils tzdata musl-locales musl-locales-lang \
    && rm -rf /var/cache/apk/*

