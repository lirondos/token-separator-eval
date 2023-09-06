import argparse
from pathlib import Path
import json
import csv

 

parser = argparse.ArgumentParser()
parser.add_argument("--input", help="path to conll_ts file to be transformed", type=str)
parser.add_argument("--output", help="path where output file will be stored", type=str)
#parser.add_argument('--is_predictions', action='store_true')

                    
args = parser.parse_args()

input = Path(args.input)
output = Path(args.output)

to_ts = []

with open(input, "r", encoding="utf-8") as f:
    with open(output, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=' ')
        tag_interruptus = None
        for line in f:
            if line.strip(): # line is not blank
                token, tag = line.split()
                if token == "||":
                    if tag != "O":
                        tag_interruptus = tag
                else: # we have a not || token
                    if tag == "O":
                        writer.writerow([token, tag])
                    else: # we have a label
                        if tag_interruptus:
                            writer.writerow([token, "I-" + tag])
                            tag_interruptus = None
                        else:
                            writer.writerow([token, "B-" + tag])
            else: #line is blank
                writer.writerow([])
            
            
           