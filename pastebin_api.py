import api_config
import urllib
import urllib.request
import os

api_dev_key = api_config.api_dev_key
username = api_config.username
password = api_config.password
api_results_limit = api_config.api_results_limit


# This is to create api_user_key (to be presented as an authenticated user)
def user_key():
    user_key_data = {'api_dev_key': api_dev_key, 'api_user_name': username, 'api_user_password': password}
    key = urllib.request.urlopen('https://pastebin.com/api/api_login.php',
                                 urllib.parse.urlencode(user_key_data).encode('utf-8'), timeout=10).read().decode()
    return key


# This is to create paste as an authenticated user
def paste(data, prv, name, exp, format):
    api_option = 'paste'
    api_paste_code = data  # paste text body
    api_paste_private = prv
    api_paste_name = name
    api_paste_expire_date = exp
    api_paste_format = format
    data = {'api_dev_key': api_dev_key, 'api_user_key': user_key(), 'api_option': api_option,
            'api_paste_code': api_paste_code, 'api_paste_private': api_paste_private,
            'api_paste_name': api_paste_name, 'api_paste_expire_date': api_paste_expire_date,
            'api_paste_format': api_paste_format}
    paste = urllib.request.urlopen('https://pastebin.com/api/api_post.php',
                                   urllib.parse.urlencode(data).encode('utf-8'), timeout=10).read().decode()
    return paste

def show_paste(paste_key):
    # Print Raw paste created by api_user
    api_option = 'show_paste'
    api_paste_key = paste_key
    data = {'api_dev_key': api_dev_key, 'api_user_key': user_key(), 'api_option': api_option,
            'api_paste_key': api_paste_key}
    req = urllib.request.urlopen('https://pastebin.com/api/api_raw.php', urllib.parse.urlencode(data).encode('utf-8'),
                                 timeout=10)
    return req.read().decode()


def delete_paste(paste_key):
    # Delete one of API user's pastes
    api_option = 'delete'
    api_paste_key = paste_key
    data = {'api_dev_key': api_dev_key, 'api_user_key': user_key(), 'api_option': api_option,
            'api_paste_key': api_paste_key}
    req = urllib.request.urlopen('https://pastebin.com/api/api_post.php', urllib.parse.urlencode(data).encode('utf-8'),
                                 timeout=10)
    return req.read().decode()


# This is to list trending pastes
def trends():
    api_option = 'trends'
    data = {'api_dev_key': api_dev_key, 'api_option': api_option}
    req = urllib.request.urlopen('https://pastebin.com/api/api_post.php', urllib.parse.urlencode(data).encode('utf-8'),
                                 timeout=10)
    return req.read()

    # This is to list authenticated user pastes


def pastelist():
    api_option = 'list'
    data = data = {'api_dev_key': api_dev_key, 'api_user_key': user_key(), 'api_option': api_option,
                   'api_results_limit': api_results_limit}
    req = urllib.request.urlopen('https://pastebin.com/api/api_post.php', urllib.parse.urlencode(data).encode('utf-8'),
                                 timeout=10)
    return req.read().decode()


# This is to show authenticated user details
def userdetails():
    api_option = 'userdetails'
    data = {'api_dev_key': api_dev_key, 'api_user_key': user_key(), 'api_option': api_option,
            'api_results_limit': api_results_limit}
    req = urllib.request.urlopen('https://pastebin.com/api/api_post.php', urllib.parse.urlencode(data).encode('utf-8'),
                                 timeout=10)
    return req.read().decode()


# This is to show raw paste
def raw_paste(paste_key):
    req = urllib.request.urlopen('https://pastebin.com/raw/' + paste_key, timeout=10)
    return req.read()


# These are available for premium lifetime users with whitelisted IP address

# This is to list recent pastes
def scraper():
    # Add ?limit=# to limit responses, max=250, default=50
    req = urllib.request.urlopen('https://pastebin.com/api_scraping.php', timeout=10)
    return req.read()


def scraper_paste(paste_key):
    req = urllib.request.urlopen('https://pastebin.com/api_scrape_item.php?i=' + paste_key, timeout=10)
    return req.read()


def scraper_paste_metadata(paste_key):
    req = urllib.request.urlopen('https://pastebin.com/api_scrape_item_meta.php?i=' + paste_key, timeout=10)
    return req.read()
