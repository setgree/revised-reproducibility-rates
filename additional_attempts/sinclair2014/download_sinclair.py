import urllib.request

files = [
    ("https://osf.io/download/553e570f8c5e4a2199199f06/", "FinalDelinkedDataSetMTurkRJ_1.sav"),
    ("https://osf.io/download/553e570f8c5e4a2199199f05/", "Codebook.pdf"),
    ("https://osf.io/download/553e570f8c5e4a2199199f07/", "Data_Output_T1_T2.pdf"),
    ("https://osf.io/download/553e570f8c5e4a2199199f04/", "Registered_Proposal.pdf"),
]

for url, filename in files:
    print(f"Downloading {filename}...")
    try:
        urllib.request.urlretrieve(url, filename)
        print(f"  ✓ {filename}")
    except Exception as e:
        print(f"  ✗ {e}")
