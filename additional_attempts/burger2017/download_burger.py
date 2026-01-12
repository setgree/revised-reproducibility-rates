import urllib.request

base_url = "https://madata.bib.uni-mannheim.de/257/"

files = [
    ("1/Burger_Bless_CRSP_Study1_Raw_Data.sav", "Study1_Raw_Data.sav"),
    ("3/Burger_Bless_CRSP_Study1_Syntax.sps", "Study1_Syntax.sps"),
    ("2/Burger_Bless_CRSP_Study1_Codebook.xls", "Study1_Codebook.xls"),
    ("5/Burger_Bless_CRSP_Study2_Raw_Data.sav", "Study2_Raw_Data.sav"),
    ("7/Burger_Bless_CRSP_Study2_Syntax.sps", "Study2_Syntax.sps"),
    ("6/Burger_Bless_CRSP_Study2_Codebook.xls", "Study2_Codebook.xls"),
]

for path, filename in files:
    url = base_url + path
    print(f"Downloading {filename}...")
    try:
        urllib.request.urlretrieve(url, filename)
        print(f"  ✓ Downloaded {filename}")
    except Exception as e:
        print(f"  ✗ Failed: {e}")
