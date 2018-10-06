#!/usr/local/bin/python
# coding=utf-8

import urllib2
import datetime
import argparse
from threading import Thread


class Requester(Thread):

    def __init__(self, until_time, path):
        super(Requester, self).__init__()
        self.until_time = until_time
        self.path = path
        self.count = 0

    def run(self):
        while datetime.datetime.now() < self.until_time:
            return_code = urllib2.urlopen(self.path).getcode()
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

    parser.add_argument('-p', '--path', required=False, default='http://127.0.0.1:3000', action='store',
                        dest='path',
                        help='HTTP address to which the requests should go')

    parser.add_argument('-s', '--seconds', required=False, default=300, action='store',
                        dest='seconds',
                        help='Maximum time that the script should run (seconds)')

    parser.add_argument('-t', '--threads', required=False, default=1, action='store',
                        dest='threads',
                        help='Quantity of threads that script should start')

    return parser.parse_args()


if __name__ == '__main__':
    main()
