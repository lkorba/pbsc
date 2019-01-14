#!/usr/bin/env python3
import pastebin_api
import sys
import argparse
import re

prv = 2
name = 'too lazy to set name'
exp = 'N'
paste_format = 'text'

parser = argparse.ArgumentParser()

group_privacy = parser.add_mutually_exclusive_group()
group_privacy.add_argument('-p', '--public', help='Post privacy will be set to public', action='store_true')
group_privacy.add_argument('-u', '--unlisted', help='Post visibility will be set to unlisted', action='store_true')

parser.add_argument('-n', '--name', action="store")

parser.add_argument('-e', '--exp', action="store", choices=['N', '10M', '1H', '1D', '1W', '2W', '1M', '6M', '1Y'],
                    help='Set expiration of the post: N = Never, 10M = 10 Minutes, 1H = 1 Hour, 1D = 1 Day, '
                         '1W = 1 Week, 2W = 2 weeks, 1M = 1 month, 6M = 6 months, 1Y = 1 year')
parser.add_argument('-f', '--format', action="store", help='Choose paste format/syntax: text=None, '
                                                           'mysql=MYSQL, perl=Perl, python=Python etc...')
parser.add_argument('-o', '--open', action="store", help='Open file')

parser.add_argument('-l', '--list', help='List your pastes', action='store_true')

args = parser.parse_args()

if args.public:
    if args.list:
        print('The -l should be used alone. Check "pb -h" for help.')
        sys.exit()
    prv = 0
    print('Post privacy set to public' + '\n')
if args.unlisted:
    if args.list:
        print('The -l should be used alone. Check "pb -h" for help.')
        sys.exit()
    prv = 0
    prv = 1
    print('Post privacy set to unlisted' + '\n')
if args.name:
    if args.list:
        print('The -l should be used alone. Check "pb -h" for help.')
        sys.exit()
    prv = 0
    name = args.name
    print('Paste name: ' + name + '\n')
if args.exp:
    if args.list:
        print('The -l should be used alone. Check "pb -h" for help.')
        sys.exit()
    prv = 0
    exp = args.exp
    print('Paste expiration set to ' + exp + '\n')
if args.format:
    if args.list:
        print('The -l should be used alone. Check "pb -h" for help.')
        sys.exit()
    prv = 0
    paste_format = args.format
    print('Paste format: ' + paste_format + '\n')
data = ''

if args.list:
    while True:
        list = '\n'.join(pastebin_api.pastelist().splitlines())
        titles = re.findall("<paste_title>(.*?)</paste_title>", list)
        keys = re.findall("<paste_key>(.*?)</paste_key>", list)
        urls = re.findall("<paste_url>(.*?)</paste_url>", list)
        print('\n\n--------------------------------------------------------')
        print('    Paste list:')
        print('--------------------------------------------------------\n')
        for item in titles:
            print(titles.index(item), item, keys[titles.index(item)], urls[titles.index(item)])
        step1 = input('\n\n--------------------------------------------------------\nDo you want to:\n\n1. Show paste\n2: Delete paste\n3. Exit\n\n> ')
        if step1 == '3':
            sys.exit()
        step2 = input('\nType paste number or "x" go back to main menu\n\n> ')
        if step2 == 'x':
            continue
        if step1 == '1':
            print('\n\n--------------------------------------------------------')
            print('    ' + titles[int(step2)] + ',  URL:  ' + urls[int(step2)])
            print('--------------------------------------------------------\n')
            print(pastebin_api.show_paste(keys[int(step2)]))
            print('\n--------------------------------------------------------\n\n')
        if step1 == '2':
            if input('\nAre you sure you want to delete ' + titles[int(step2)] + '?\nType "yes" to delete.\n\n> ') == 'yes':
                print('\n' + pastebin_api.delete_paste(keys[int(step2)]) + '\n')
if not args.list:
    if args.open:
        print('Opening file: ' + args.open + '\n')
        with open(args.open, 'r') as f:
            data = f.read()
    else:
        for line in sys.stdin:
            data = data + line
    try:
        print(pastebin_api.paste(data, prv, name, exp, paste_format))
    except Exception as e:
        print("[!] API Error:", e)
