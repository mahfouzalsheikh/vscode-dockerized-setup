FROM python:3.10.1-buster

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash-completion \
    && pip install --upgrade pip \
    && pip install pipenv --no-cache-dir \
    && rm -rf /var/lib/apt/lists/*

ENV API_ROOT /vscode-dockerized-setup/src
RUN mkdir -p $API_ROOT

WORKDIR $API_ROOT

COPY src/Pipfile src/Pipfile.lock ${API_ROOT}/



ARG DEBUG

RUN set -x && \
    if [ "$DEBUG" = "1" ]; then \
        (unset DEBUG; pipenv install --clear --system -d); \
    else \
        (unset DEBUG; pipenv install --clear --system); \
    fi

ARG USER_UID
ARG USER_GID

RUN set -x  \
    && if [ ! $(getent group ${USER_GID:-${USER_UID:-1000}}) ]; then \
        groupadd apiuser --gid=${USER_GID:-${USER_UID:-1000}}; \
    fi \
    && useradd -d /home/apiuser -m --gid=${USER_GID:-${USER_UID:-1000}} --uid=${USER_UID:-1000} apiuser

COPY src $API_ROOT/
RUN chown -R ${USER_UID:-1000}:${USER_GID:-${USER_UID:-1000}} $API_ROOT

USER apiuser
RUN mkdir -p /home/apiuser/.vscode-server/data/Machine

# Any command that will keep the container alive
# Later on would be replaced by the service the container will be running
ENTRYPOINT ["tail", "-f", "/dev/null"]
