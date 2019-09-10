#!/usr/bin/env python3
import lib.pbstc_api as pastebin_api
import sys
import argparse
import re
import prettytable as pt

prv = 2
prvtext = 'private'
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
    prvtext = 'public'
    print('Post privacy set to public' + '\n')
if args.unlisted:
    if args.list:
        print('The -l should be used alone. Check "pb -h" for help.')
        sys.exit()
    prvtext = 'unlusted'
    prv = 1
    print('Post privacy set to unlisted' + '\n')
if args.name:
    if args.list:
        print('The -l should be used alone. Check "pb -h" for help.')
        sys.exit()
    name = args.name
    print('Paste name: ' + name + '\n')
if args.exp:
    if args.list:
        print('The -l should be used alone. Check "pb -h" for help.')
        sys.exit()
    exp = args.exp
    print('Paste expiration set to ' + exp + '\n')
if args.format:
    if args.list:
        print('The -l should be used alone. Check "pb -h" for help.')
        sys.exit()
    paste_format = args.format
    print('Paste format: ' + paste_format + '\n')

data = ''
userdata=pastebin_api.userdetails()
username = re.findall("<user_name>(.*?)</user_name>", userdata)[0]
account = re.findall("<user_account_type>(.*?)</user_account_type>", userdata)[0]
if account == '1':
    account = 'PRO'
elif account == '0':
    account = 'normal'
else:
    account == 'Unknown account type'

print(f'Your username is {username} and your account type is {account}\n')
if args.list:
    while True:
        list = '\n'.join(pastebin_api.pastelist().splitlines())
        titles = re.findall("<paste_title>(.*?)</paste_title>", list)
        keys = re.findall("<paste_key>(.*?)</paste_key>", list)
        urls = re.findall("<paste_url>(.*?)</paste_url>", list)
        formats = re.findall("<paste_format_long>(.*?)</paste_format_long>", list)
        print('\n\n--------------------------------------------------------')
        print('    Paste list:')
        print('--------------------------------------------------------\n')
        pastelist = []
        for item in keys:
            pastelist.append([keys.index(item), titles[keys.index(item)], urls[keys.index(item)], formats[keys.index(item)]])
        x = pt.PrettyTable(['Index','Title','URL','Format'])
        for item in pastelist:
            x.add_row(item)
        print(x)


        step1 = input('\n\n--------------------------------------------------------\nDo you want to:\n\n1. Show paste\n2: Delete paste\n3. Exit\n\n> ')
        if step1 not in ('1', '2', '3'):
            print(f'{step1} is not a valid choice')
            continue
        if step1 == '3':
            sys.exit()
        step2 = input('\nType paste number or "x" go back to main menu\n\n> ')
        try:
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
        except Exception as e:
            print(f'{step2} is not a valid choice')
            continue
if not args.list:
    if args.open:
        print('Opening file: ' + args.open + '\n')
        with open(args.open, 'r') as f:
            data = f.read()
    else:
        print("Start typing, press Ctrl+d when finished")
        for line in sys.stdin:
            data = data + line
    try:
        print(f'Your paste titled "{name}" has privacy set to {prvtext}, format is {paste_format}, expiration is set to {exp}.\n')
        print(pastebin_api.paste(data, prv, name, exp, paste_format))
    except Exception as e:
        print("[!] API Error:", e)
