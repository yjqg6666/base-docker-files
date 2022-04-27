FROM alpine:3.15.4

CMD ["/bin/sh"]

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN sed -i"" -e "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

RUN apk -U upgrade
RUN apk add --no-cache coreutils tzdata musl-locales musl-locales-lang doas axel

# https://wiki.alpinelinux.org/wiki/Setting_up_a_new_user
RUN def_passwd=$(tr -dc 'A-Za-z0-9!@#$&*' < /dev/urandom |head -c 16) && echo $def_passwd
ENV APP_USER=app
ARG APP_USER_PASSWD=$def_passwd
RUN adduser -D $APP_USER \
    && echo $APP_USER_PASSWD && echo "$APP_USER:$APP_USER_PASSWD" | chpasswd  \
    && echo "permit nopass $APP_USER" >> /etc/doas.d/doas.conf

RUN mkdir /var/log/$APP_USER && chown $APP_USER:$APP_USER /var/log/$APP_USER

USER $APP_USER
RUN mkdir /home/$APP_USER/app
WORKDIR /home/$APP_USER/app

# allow "sub-dockerfile" to alter normal user passwd
# https://docs.docker.com/engine/reference/builder/#onbuild
#ONBUILD USER root
#ONBUILD RUN echo $APP_USER_PASSWD && echo "$APP_USER:$APP_USER_PASSWD" | chpasswd
