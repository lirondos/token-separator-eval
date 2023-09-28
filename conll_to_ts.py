import argparse
from pathlib import Path
import json
import csv

PUNCTUATION_NOT_PRECEEDED = [",",":",";", ".", "!", "?", ")", "]", "-", "´"] # punctuation signs not preceeded by space
PUNCTUATION_NOT_FOLLOWED = ["¡", "¿", "(", "[", "-"] # punctuation signs not followed by space


parser = argparse.ArgumentParser()
parser.add_argument("--input", help="path to conll file to be transformed", type=str)
parser.add_argument("--output", help="path where output file will be stored", type=str)
parser.add_argument('--is_flair', action='store_true')

                    
args = parser.parse_args()

input = Path(args.input)
output = Path(args.output)

to_ts = []

with open(input, "r", encoding="utf-8") as f:
    lines = f.readlines()
    lines.reverse()
    for line in lines:
        if line.strip(): # line is not blank
            if args.is_flair: # we expect 3 columns
                token, _, tag = line.split()
            else:
                token, tag = line.split()
            if token in PUNCTUATION_NOT_FOLLOWED:
                if to_ts and len(to_ts[0])==2 and to_ts[0][0] == "||":
                    to_ts.pop(0)
            if tag == "O":
                to_ts.insert(0, (token, tag))
                if token in PUNCTUATION_NOT_PRECEEDED: 
                    continue
                to_ts.insert(0, ("||", "O"))
            else: # B or I label
                prefix, label = tag.split("-", 1) # we split on the first hyphen (bc "B-creative-work")
                if prefix == "I":
                    to_ts.insert(0, (token, label))
                    if token in PUNCTUATION_NOT_PRECEEDED: 
                        continue
                    to_ts.insert(0, ("||", label))
                elif prefix == "B":
                    to_ts.insert(0, (token, label))
                    if token in PUNCTUATION_NOT_PRECEEDED: 
                        continue
                    to_ts.insert(0, ("||", "O"))

        else: # line is blank
            if to_ts and len(to_ts[0])==2 and to_ts[0][0] == "||": # avoid popping the first time bc list is empty
                to_ts.pop(0) # we remove the extra empty space
            to_ts.insert(0, ())
    
    if to_ts[0][0] == "||": # PUNCTUATION_NOT_PRECEEDED chars won't add extra space so we check first
        to_ts.pop(0) # we remove the last extra space added on the first line

with open(output, 'w', newline='') as csvfile:
    writer = csv.writer(csvfile, delimiter=' ', quoting=csv.QUOTE_NONE, quotechar=None)
    for item in to_ts:
        if item: # tuple is not empty
            writer.writerow([item[0], item[1]])
        else: # tuple is empty, we add blank line
            writer.writerow([])
            
            
           