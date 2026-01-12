import urllib.request

files = [
    ("https://osf.io/download/553e84d68c5e4a21991a6b42/", "Codebook.pdf"),
    ("https://osf.io/download/553e84d68c5e4a21991a6b3e/", "Communication_DV.sav"),
    ("https://osf.io/download/553e84d68c5e4a21991a6b40/", "Proposal.docx"),
    ("https://osf.io/download/553e84d68c5e4a21991a6b3f/", "Votes_and_Committees.sav"),
    ("https://osf.io/download/553e84d68c5e4a21991a6b41/", "DV_packet.pdf"),
]

for url, filename in files:
    print(f"Downloading {filename}...")
    try:
        urllib.request.urlretrieve(url, filename)
        print(f"  ✓ {filename}")
    except Exception as e:
        print(f"  ✗ {e}")
