import json
import requests
import sys

with open("modrinth.index.json") as file:
    files = json.load(file)

for file in files["files"]:
    if "server" in file["env"] and "required" in file["env"]["server"]:
        resp = requests.get(file["downloads"][0])
        if resp.status_code != 200:
            raise requests.HTTPError(resp.status_code)
        print(file["path"], file=sys.stderr)
        with open(file["path"], "wb") as file:
            file.write(resp.content)

