FROM python:2.7.15-alpine

LABEL maintainer="Tiago M Reichert <tiago@reichert.eti.br>"

# Copy script which should be run
COPY ./parser.py /scripts/parser.py
RUN chmod +x /scripts/parser.py
RUN apk add curl bash tzdata && rm -rf /var/cache/apk/*

# Copy entrypoint and give execuation rights
COPY ./entrypoint.sh /scripts/entrypoint.sh
RUN chmod +x /scripts/entrypoint.sh

ENV CRON_MASK='00  22  *  *  *'

ENTRYPOINT ["/scripts/entrypoint.sh"]