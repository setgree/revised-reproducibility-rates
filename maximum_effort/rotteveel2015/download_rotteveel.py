import urllib.request
import os

files = [
    ("https://osf.io/download/eibv6/", "data.zip"),
    ("https://osf.io/download/e2ryf/", "code.zip")
]

for url, filename in files:
    print(f"Downloading {filename}...")
    urllib.request.urlretrieve(url, filename)
    print(f"Downloaded {filename}")
