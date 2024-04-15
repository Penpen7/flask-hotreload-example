FROM python:3.11.8-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl
# watchexec-cliのインストール
RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
ENV PATH /root/.cargo/bin:${PATH}
RUN cargo-binstall -y watchexec-cli

# ryeのインストール
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
CMD . .venv/bin/activate && watchexec -r --exts py -v -- python3 ./src/flask_hotreload/__init__.py
