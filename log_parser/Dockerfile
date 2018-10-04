FROM python:2.7.15-alpine

# Install requirements
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
RUN rm /requirements.txt

# Copy script which should be run
COPY ./parser.py /scripts/parser.py
RUN chmod +x /scripts/parser.py
RUN apk add curl bash tzdata && rm -rf /var/cache/apk/*

# Run the cron every minute
RUN echo '00  22  *  *  *    /scripts/parser.py' > /etc/crontabs/root

CMD ["crond", "-f"]