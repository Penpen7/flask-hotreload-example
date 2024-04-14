FROM python:3.11-alpine3.19

RUN apk add watchexec curl
# WORKDIR /python/.rye
# ENV RYE_HOME /python/.rye
# RUN curl -sSf https://rye-up.com/get | RYE_VERSION="0.4.0" RYE_INSTALL_OPTION="--yes" sh
WORKDIR /app
RUN --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=requirements.lock,target=requirements.lock \
    --mount=type=bind,source=requirements-dev.lock,target=requirements-dev.lock \
    --mount=type=bind,source=.python-version,target=.python-version \
    --mount=type=bind,source=README.md,target=README.md \
    PYTHONDONTWRITEBYTECODE=1 pip install --no-cache-dir -r requirements.lock
CMD ["watchexec", "-r", "--exts", "py", "-v", "--", "python3", "./src/flask_hotreload/__init__.py"]
