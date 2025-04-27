import zipfile
import sys

zip_path = 'walmart-10k-sales-datasets.zip'
extract_to = './walmart_extracted/'

try:
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(extract_to)
    print(f"Extraction completed successfully to {extract_to}")
except zipfile.BadZipFile:
    print("Error: The zip file is corrupted or not a zip file.")
except NotImplementedError as e:
    print(f"Error: {e}")
    print("This zip file may use a compression method not supported by the zipfile module.")
except Exception as e:
    print(f"An unexpected error occurred: {e}")
