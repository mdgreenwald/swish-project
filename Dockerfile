FROM python:3.11.4-slim-buster

COPY pyproject.toml poetry.lock .

COPY src/ ./src

RUN pip install poetry && poetry install --only main

