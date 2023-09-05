import argparse
from pathlib import Path
import json
import csv

 

parser = argparse.ArgumentParser()
parser.add_argument("--json_file", help="path to json", type=str)
parser.add_argument("--output", help="path to output file", type=str)
                    
args = parser.parse_args()

json_file = Path(args.json_file)

with open(args.output, 'w', newline='') as tsvfile:
    writer = csv.writer(tsvfile, delimiter='\t', lineterminator='\n')
    
    with open(json_file) as f:
        for line in f:
            item = json.loads(line)
            for token, tag in zip(item["tokens"], item["ner"]):
                writer.writerow([token, tag])
            writer.writerow(None)
            writer.writerow(None)