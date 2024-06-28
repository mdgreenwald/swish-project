FROM python:3.11.9-slim-buster

COPY pyproject.toml poetry.lock .

COPY src/ ./src

RUN pip install poetry && poetry install --only main

