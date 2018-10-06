FROM python:2.7.15-alpine

LABEL maintainer="Tiago M Reichert <tiago@reichert.eti.br>"

COPY ./analyzer.py /app/analyzer.py
RUN chmod +x /app/analyzer.py

CMD [ "python", "/app/analyzer.py" ]
