# pbstc - pastebin simple terminal client

Rename pbstc_api_config.py.example to pbstc_api_config.py and configure API key, username, password
You will find your API key here: https://pastebin.com/api

It is best to add folder with this script to PATH (don't forget to "chmod +x pb" if running in Linux)

## Example usage:

```
ls | pb
```

This will paste output of "ls" command as private, never expiry with a default name: name "too lazy to set the name"

```
pb -o file.py -n "Paste Name" -f python -e 1H -u
```

This will send file "file.py" with title "Paste Name", as unlisted, with python syntax and expire set to 1 hour

Make sure to check help with

```
pb -h
```


