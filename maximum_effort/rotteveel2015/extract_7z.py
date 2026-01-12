import subprocess
import os

# Try using Python's py7zr if available, otherwise use system command
try:
    import py7zr
    print("Using py7zr to extract...")
    with py7zr.SevenZipFile('data.7z', mode='r') as z:
        z.extractall()
    print("Extraction complete!")
except ImportError:
    print("py7zr not available, trying system commands...")
    # Try unar (common on macOS)
    try:
        result = subprocess.run(['unar', 'data.7z'], capture_output=True, text=True)
        print(result.stdout)
        print(result.stderr)
    except FileNotFoundError:
        print("unar not found either. Available extraction tools on this system:")
        subprocess.run(['which', 'unzip', 'tar', 'gunzip'], capture_output=False)
