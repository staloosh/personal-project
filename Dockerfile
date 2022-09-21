## This Dockerfile is structured as a multi-stage build in order to have a smaller image at the end and reduce attack surface
FROM debian:stable-slim as builder

COPY checksum.sh /

## Public key of Adrian Gallagher was downloaded based on documentation https://download.litecoin.org/README-HOWTO-GPG-VERIFY-TEAM-MEMBERS-KEY.txt
COPY public.key /

## Defining LTC_VER as an environment variable and not ARG so that the checksum script can call it
ENV LTC_VER="0.18.1"

## Defining build arguments
ARG PACKAGE_URL="https://download.litecoin.org/litecoin-${LTC_VER}/linux/litecoin-${LTC_VER}-x86_64-linux-gnu.tar.gz" \
    PACKAGE_URL_SIGNATURE="https://download.litecoin.org/litecoin-${LTC_VER}/linux/litecoin-${LTC_VER}-x86_64-linux-gnu.tar.gz.asc" \
    PACKAGE_SIGNATURES="https://download.litecoin.org/litecoin-${LTC_VER}/linux/litecoin-${LTC_VER}-linux-signatures.asc"

RUN set -x \
    && mkdir /crypto \
    && useradd -m -d /crypto/litecoin-${LTC_VER}/bin litecoin

RUN set -x \
    && apt-get -y update \
    && apt-get -y install wget gpg \
    && wget ${PACKAGE_URL} \
    && wget ${PACKAGE_URL_SIGNATURE} \
    && wget ${PACKAGE_SIGNATURES} \
    && gpg --import public.key \
    && gpg --verify litecoin-${LTC_VER}-x86_64-linux-gnu.tar.gz.asc \
    && tar -xzvf litecoin-${LTC_VER}-x86_64-linux-gnu.tar.gz -C /crypto 

## A remove package step is not needed as we are using a multi-stage build

## Ensure script is executable and execute it
RUN set -x \
    && chmod ug+x checksum.sh \
    && /bin/bash checksum.sh

FROM debian:stable-slim
ARG BUILD_DATE="2022-09-19T21:51:56Z" \
    APPLICATION_NAME="Litecoin app" \
    BUILD_VERSION="1.0" \
    LTC_VER="0.18.1"
    
LABEL maintainer="Bogdan Astalus (bogdan@staloosh.eu)" \
      org.label-schema.name="Litecoin app" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.application=$APPLICATION_NAME \
      org.label-schema.schema-version="1.0" \
      org.label-schema.version=$BUILD_VERSION \
      org.label-schema.docker.cmd="docker run -dit --name=litecoin -p 9332:9332 litecoind:latest"

RUN set -x \
    && mkdir /appdata \
    && useradd -m -d /crypto/litecoin-${LTC_VER}/bin litecoin \
    && chown -R litecoin:litecoin /appdata

COPY --from=builder --chown=litecoin:litecoin /crypto /crypto
WORKDIR /crypto/litecoin-${LTC_VER}/bin

EXPOSE 9333
USER litecoin

ENTRYPOINT [ "./litecoind" ]
