FROM python:3.11.8-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl
RUN curl -fsSL https://apt.cli.rs/pubkey.asc | tee -a /usr/share/keyrings/rust-tools.asc
RUN curl -fsSL https://apt.cli.rs/rust-tools.list | tee /etc/apt/sources.list.d/rust-tools.list
RUN apt update && apt install watchexec-cli && apt clean && rm -rf /var/lib/apt/lists/*
ENV RYE_HOME /opt/rye
ENV PATH ${RYE_HOME}/shims:${PATH}
RUN curl -sSf https://rye-up.com/get | RYE_INSTALL_OPTION="--yes" bash
WORKDIR /app
RUN --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=requirements.lock,target=requirements.lock \
    --mount=type=bind,source=requirements-dev.lock,target=requirements-dev.lock \
    --mount=type=bind,source=.python-version,target=.python-version \
    --mount=type=bind,source=README.md,target=README.md \
    rye sync --no-dev --no-lock
RUN . .venv/bin/activate
CMD ["watchexec", "-r", "--exts", "py", "-v", "--", "python3", "./src/flask_hotreload/__init__.py"]
