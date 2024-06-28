FROM python:3.9.0-slim-buster

COPY pyproject.toml poetry.lock .

COPY src/ ./src

RUN pip install poetry && poetry install --only main

