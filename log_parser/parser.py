#!/usr/local/bin/python
# coding=utf-8
import subprocess
import smtplib
import os
import argparse
from email.mime.multipart import MIMEMultipart
from email.MIMEText import MIMEText
import logging
import sys


def main():
    logging.basicConfig(stream=sys.stdout, format='%(asctime)s [%(levelname)s] %(message)s', level=logging.INFO)
    args = parse_args()
    send_email(args=args, message=parse_logs(args.sevice_name))


def parse_logs(sevice_name):
    # Bash command to parse logs
    command = "curl -s --unix-socket /var/run/docker.sock http:/v1.24/services/%s/logs?stdout=1 " \
              "| awk '{print $7\" \"$9}' | sort | grep -v '^ *$' |  uniq -c | sed -e 's/^[ \t]*//'" % sevice_name
    return subprocess.check_output(['bash', '-c', command])


def send_email(args, message):
    # Connect to SMTP server
    server = smtplib.SMTP(args.smtp_server, args.smtp_port)
    # Enable TLS
    if args.smtp_tls:
        server.ehlo()
        server.starttls()
        server.ehlo()
    # Authenticate
    server.login(args.smtp_username, args.smtp_password)
    # Build message
    smtp_recipient = args.smtp_recipient.split(";")
    msg = MIMEMultipart()
    msg['From'] = '%s <%s>' % (args.smtp_name, args.smtp_username)
    msg['To'] = ', '.join(smtp_recipient)
    msg['Subject'] = "Cloud Challenge - Log Parser"
    msg.attach(MIMEText(message, 'plain'))
    # Send message
    server.sendmail(args.smtp_username, smtp_recipient, msg.as_string())
    logging.info('Sent email with current log status!')


def parse_args():

    parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument('--smtp_server', default=os.environ.get('SMTP_SERVER', None))
    parser.add_argument('--smtp_port', default=os.environ.get('SMTP_PORT', None))
    parser.add_argument('--smtp_tls', default=os.environ.get('SMTP_TLS', None))
    parser.add_argument('--smtp_name', default=os.environ.get('SMTP_NAME', None))
    parser.add_argument('--smtp_username', default=os.environ.get('SMTP_USERNAME', None))
    parser.add_argument('--smtp_password', default=os.environ.get('SMTP_PASSWORD', None))
    parser.add_argument('--smtp_recipient', default=os.environ.get('SMTP_RECIPIENT', None))
    parser.add_argument('--service_name', default=os.environ.get('SERVICE_NAME', None))

    return parser.parse_args()


if __name__ == '__main__':
    main()
