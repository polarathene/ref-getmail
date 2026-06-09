#FROM ghcr.io/astral-sh/uv:0.11.17-alpine3.23
FROM fedora:44
ARG TINI_VERSION=v0.19.0
ADD --chmod=+x https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini

COPY --link --from=ghcr.io/astral-sh/uv:0.11 /uv /usr/local/bin/uv
ENV UV_TOOL_BIN_DIR=/usr/local/bin
ARG PYTHON_RELEASE=3.14
RUN uv python install "${PYTHON_RELEASE}-$(uname --machine)-gnu"
RUN <<HEREDOC
  uv tool install getmail==6.19.12
  uv tool install supervisor==4.3.0
HEREDOC

COPY docker/build/supervisor /etc/supervisor
RUN mkdir -p /var/log/supervisor/

ENTRYPOINT ["tini", "--"]
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
