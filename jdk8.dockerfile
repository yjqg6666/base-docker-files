FROM yjqg6666/alpine:v3.15.4


ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"

ENV JAVA_VERSION jdk8u322-b06

#reference: 
# 1. https://github.com/docker-library/docs/tree/master/eclipse-temurin
# 2. https://github.com/adoptium/containers/blob/3cce04581c9f160bacf9052510b43ad9aeef7c8f/8/jdk/alpine/Dockerfile.releases.full
RUN set -eux; \
    ARCH="$(apk --print-arch)"; \
    case "${ARCH}" in \
       amd64|x86_64) \
         ESUM='c7e781064c4a63ad6cd2399b2fa34de854a7d9bfd3ad2543d34bd7ba8f818822'; \
         BINARY_URL='https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jdk_x64_alpine-linux_hotspot_8u322b06.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
	  wget -O /tmp/openjdk.tar.gz ${BINARY_URL}; \
	  echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
	  mkdir -p /opt/java/openjdk; \
	  tar --extract \
	      --file /tmp/openjdk.tar.gz \
	      --directory /opt/java/openjdk \
	      --strip-components 1 \
	      --no-same-owner \
	  ; \
    rm -rf /tmp/openjdk.tar.gz;


RUN echo "Verifying install ..." \
    && echo "javac -version" && javac -version \
    && echo "java -version" && java -version \
    && echo "Complete."
