FROM alpine:3.5
MAINTAINER smizy

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="Apache License 2.0" \
    org.label-schema.name="smizy/presto" \
    org.label-schema.url="https://github.com/smizy" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.version=$VERSION \
    org.label-schema.vcs-url="https://github.com/smizy/docker-presto"


ENV PRESTO_VERSION       ${VERSION}
ENV PRESTO_HOME          /usr/local/presto-server-${PRESTO_VERSION}
ENV PRESTO_CONF_DIR      ${PRESTO_HOME}/etc
ENV PRESTO_NODE_DATA_DIR /presto
ENV PRESTO_LOG_DIR       /var/log/presto
ENV PRESTO_JVM_MAX_HEAP  16G 

ENV PRESTO_QUERY_MAX_MEMORY          20GB 
ENV PRESTO_QUERY_MAX_MEMORY_PER_NODE 1GB 

ENV PRESTO_DISCOVERY_URI  http://coordinator-1.vnet:8080 

ENV JAVA_HOME   /usr/lib/jvm/default-jvm
ENV PATH        $PATH:${JAVA_HOME}/bin:${PRESTO_HOME}/bin


RUN set -x \
    && apk update \
    && apk --no-cache add \
        bash \
        less \
        openjdk8-jre \
        python \
        su-exec \
        tar \ 
        wget \
    ## presto-server
    && wget -q -O - https://repo1.maven.org/maven2/com/facebook/presto/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz \
        | tar -xzf - -C /usr/local  \
    ## presto-client
    && wget -q -O /usr/local/bin/presto https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar \
    && chmod +x /usr/local/bin/presto \
    ## user/dir/permmsion
    && adduser -D  -g '' -s /sbin/nologin -u 1000 docker \
    && adduser -D  -g '' -s /sbin/nologin presto \
    && mkdir -p \
        ${PRESTO_CONF_DIR} \
        ${PRESTO_LOG_DIR} \
        ${PRESTO_NODE_DATA_DIR} \
    && chown -R presto:presto \
        ${PRESTO_HOME} \
        ${PRESTO_LOG_DIR} \
        ${PRESTO_NODE_DATA_DIR}
    
COPY etc/  ${PRESTO_CONF_DIR}/
COPY bin/*  /usr/local/bin/
COPY lib/*  /usr/local/lib/

VOLUME ["${PRESTO_LOG_DIR}", "${PRESTO_NODE_DATA_DIR}"]

WORKDIR ${PRESTO_HOME}

ENTRYPOINT ["entrypoint.sh"]
