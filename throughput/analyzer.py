#!/usr/local/bin/python
# coding=utf-8

import urllib2
import datetime
import argparse
from threading import Thread
import os
import ssl

class Requester(Thread):

    def __init__(self, until_time, path):
        super(Requester, self).__init__()
        self.until_time = until_time
        self.path = path
        self.count = 0

    def run(self):
        context = ssl._create_unverified_context()
        while datetime.datetime.now() < self.until_time:
            return_code = urllib2.urlopen(self.path, context=context).getcode()
            if return_code == 200:
                self.count += 1
            else:
                break


def main():

    p = parse_args()

    begin = datetime.datetime.now()

    threads = [Requester(until_time=begin+datetime.timedelta(seconds=int(p.seconds)), path=p.path)
               for _ in xrange(int(p.threads))]

    [thread.start() for thread in threads]
    [thread.join() for thread in threads]

    count = sum([thread.count for thread in threads])
    total_time = datetime.datetime.now() - begin
    try:
        req_per_second = count / total_time.seconds
    except ZeroDivisionError:
        req_per_second = 0
    print '%s requests during %s [%s req/s]' % (count, total_time, req_per_second)


def parse_args():

    parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument('--path', default=os.environ.get('PATH', None))
    parser.add_argument('--seconds', default=os.environ.get('SECONDS', None))
    parser.add_argument('--threads', default=os.environ.get('THREADS', None))

    return parser.parse_args()


if __name__ == '__main__':
    main()
