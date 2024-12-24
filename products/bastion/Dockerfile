FROM alpine:3.11.6

LABEL maintainer="Matthew Baggett <matthew@baggett.me>"

ARG HOME=/var/lib/bastion

ARG USER=bastion
ARG GROUP=bastion
ARG UID=1000
ARG GID=1000

ENV HOST_KEYS_PATH_PREFIX="/usr"
ENV HOST_KEYS_PATH="${HOST_KEYS_PATH_PREFIX}/etc/ssh"

COPY bastion.sh /usr/sbin/bastion

RUN addgroup -S -g ${GID} ${GROUP} \
    && adduser -D -h ${HOME} -s /bin/ash -g "${USER} service" \
           -u ${UID} -G ${GROUP} ${USER} \
    && sed -i "s/${USER}:!/${USER}:*/g" /etc/shadow \
    && set -x \
    && apk add --no-cache openssh-server bash \
    && echo "Welcome to Bastion!" > /etc/motd \
    && chmod +x /usr/sbin/bastion \
    && mkdir -p ${HOST_KEYS_PATH} \
    && mkdir /etc/ssh/auth_principals \
    && echo "bastion" > /etc/ssh/auth_principals/bastion

EXPOSE 22/tcp

VOLUME ${HOST_KEYS_PATH}

ENTRYPOINT ["bastion"]