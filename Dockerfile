ARG CDPG_TAG

FROM registry.developers.crunchydata.com/crunchydata/crunchy-postgres:${CDPG_TAG}

ARG TARGETARCH
# renovate: datasource=github-releases depName=tensorchord/VectorChord
ARG VECTORCHORD_TAG=0.4.2
ARG CDPG_TAG

# drop to root to copy files
USER root

RUN PG_MAJOR=$(echo "$CDPG_TAG" | cut -d'-' -f2 | cut -d'.' -f1) && \
    case "$TARGETARCH" in \
        amd64) URLARCH="x86_64-linux" ;; \
        arm64) URLARCH="aarch64-linux" ;; \
        *) echo "Unsupported architecture: $TARGETARCH" && exit 1 ;; \
    esac && \
    curl -L \
        "https://github.com/tensorchord/VectorChord/releases/download/${VECTORCHORD_TAG}/postgresql-${PG_MAJOR}-vchord_${VECTORCHORD_TAG}_${URLARCH}-gnu.zip" \
        -o /tmp/vchord.zip && \
    unzip /tmp/vchord.zip -d /tmp && \
    case "$VECTORCHORD_TAG" in \
        "0.3.0"|"0.4.0"|"0.4.1") \
            cp /tmp/vchord.so $(pg_config --pkglibdir) && \
            cp /tmp/vchord.control $(pg_config --sharedir)/extension && \
            cp /tmp/vchord-*.sql $(pg_config --sharedir)/extension && \
            rm -rf /tmp/vchord*;; \
        *) \
            cp -r /tmp/pkglibdir/. $(pg_config --pkglibdir) && \
            cp -r /tmp/sharedir/. $(pg_config --sharedir) && \
            rm -rf /tmp/vchord.zip /tmp/pkglibdir /tmp/sharedir ;; \
    esac

USER 26
