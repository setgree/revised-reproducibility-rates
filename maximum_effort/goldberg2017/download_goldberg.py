import urllib.request

files = [
    ("https://osf.io/download/ke6f3/", "CRSP_Data_Deidentified.csv"),
    ("https://osf.io/download/4p7ma/", "CRSP_variable_names.csv")
]

for url, filename in files:
    print(f"Downloading {filename}...")
    urllib.request.urlretrieve(url, filename)
    print(f"Downloaded {filename}")
