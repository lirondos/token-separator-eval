import argparse
from pathlib import Path
import json
import csv

 

parser = argparse.ArgumentParser()
parser.add_argument("--input", help="path to conll file to be transformed", type=str)
parser.add_argument("--output", help="path where output file will be stored", type=str)
#parser.add_argument('--is_predictions', action='store_true')

                    
args = parser.parse_args()

input = Path(args.input)
output = Path(args.output)

to_ts = []

with open(input, "r", encoding="utf-8") as f:
    lines = f.readlines()
    lines.reverse()
    for line in lines:
        if line.strip(): # line is not blank
            token, tag = line.split()
            if tag == "O":
                to_ts.insert(0, (token, tag))
                to_ts.insert(0, ("||", "O"))
            else: # B or I label
                prefix, label = tag.split("-", 1) # we split on the first hyphen (bc "B-creative-work")
                if prefix == "I":
                    to_ts.insert(0, (token, label))
                    to_ts.insert(0, ("||", label))
                elif prefix == "B":
                    to_ts.insert(0, (token, label))
                    to_ts.insert(0, ("||", "O"))

        else: # line is blank
            if to_ts: # avoid popping the first time bc list is empty
                to_ts.pop(0) # we remove the extra empty space
            to_ts.insert(0, ())
    
    to_ts.pop(0) # we remove the last extra space added on the first line

with open(output, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter=' ')
    for item in to_ts:
        if item: # tuple is not empty
            writer.writerow([item[0], item[1]])
        else: # tuple is empty, we add blank line
            writer.writerow([])
            
            
           