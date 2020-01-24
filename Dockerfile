FROM: alpine

LABEL \
  "name"="GitHub Repository Sync" \
  "repository"="https://github.com/Andre601/repository-sync" \
  "maintainer"="Andre_601"

RUN apk add --no-cache git openssh-client && \
  echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
