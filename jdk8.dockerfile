FROM yjqg6666/alpine:v3.15.4

ENV JAVA_VERSION jdk8u322-b06

USER root

# install JDK 8
#reference: 
# 1. https://github.com/docker-library/docs/tree/master/eclipse-temurin
# 2. https://github.com/adoptium/containers/blob/3cce04581c9f160bacf9052510b43ad9aeef7c8f/8/jdk/alpine/Dockerfile.releases.full
#RUN url='https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jdk_x64_alpine-linux_hotspot_8u322b06.tar.gz' && axel --num-connections 10 --output /tmp/openjdk.tar.gz $url
COPY ./OpenJDK8U-jdk_x64_alpine-linux_hotspot_8u322b06.tar.gz /tmp/openjdk.tar.gz

ENV APP_USER=app
ENV JAVA_HOME="/home/${APP_USER}/jdk"
ENV PATH="${JAVA_HOME}/bin:$PATH"

RUN set -eux \
    && cksum='c7e781064c4a63ad6cd2399b2fa34de854a7d9bfd3ad2543d34bd7ba8f818822' \
    && echo "$cksum /tmp/openjdk.tar.gz" | sha256sum -c - \
    && mkdir -p "${JAVA_HOME}" \
    && tar --extract \
      --file /tmp/openjdk.tar.gz \
      --directory "${JAVA_HOME}" \
      --strip-components 1 \
      --no-same-owner \
    && rm -rf /tmp/openjdk.tar.gz;

## runtime setup
USER $APP_USER

RUN javac -version && java -version

ONBUILD ARG JAR_RPATH
ONBUILD RUN test -n "$JAR_RPATH" || (echo "Error: --build-arg JAR_RPATH=target/***.jar is needed but not provided." && exit 128)
ONBUILD ENV JAR_APATH=/home/app/app/app.jar
ONBUILD COPY ${JAR_RPATH} ${JAR_APATH}

CMD ["java","-jar","/home/app/app/app.jar"]
