FROM python:2.7.15-alpine

LABEL maintainer="Tiago M Reichert <tiago@reichert.eti.br>"

RUN apk add bash python && rm -rf /var/cache/apk/*

COPY ./analyzer.py /app/analyzer.py

ENV PATH='https://127.0.0.1' \
    SECONDS=30 \
    THREADS=1

CMD [ "python", "/app/analyzer.py" ]
