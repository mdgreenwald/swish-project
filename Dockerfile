FROM python:3.9.0-slim-buster

COPY pyproject.toml poetry.lock .

RUN pip install poetry && poetry install --only main --no-root --no-directory

COPY src/ ./src

RUN poetry install --only main