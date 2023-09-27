import argparse
from pathlib import Path
import json
import csv
from collections import defaultdict
 

parser = argparse.ArgumentParser()
parser.add_argument("--predicted", help="path to conll file to be transformed", type=str)
parser.add_argument("--goldstandard", help="path where output file will be stored", type=str)
parser.add_argument('--only_tokens', action='store_true')

                    
args = parser.parse_args()

predicted = Path(args.predicted)
goldstandard = Path(args.goldstandard)

counts = defaultdict(lambda: defaultdict(int))

to_ts = []
tp = 0
fn = 0
fp = 0

with open(predicted, "r", encoding="utf-8") as predicted_file, open(goldstandard, "r", encoding="utf-8") as goldstandard_file:
    for predicted_line, goldstandard_line in zip(predicted_file, goldstandard_file):
        if predicted_line.strip() and goldstandard_line.strip(): # lines are not blank
            predicted_token, predicted_tag = predicted_line.split()
            goldstandard_token, goldstandard_tag = goldstandard_line.split()
            if args.only_tokens and goldstandard_token == "||":
                continue
            if goldstandard_token != predicted_token:
                print("Mismatch between files")
                print("Goldstandard: " + goldstandard_token)
                print("Prediction: " + predicted_token)
                break
            if predicted_tag == goldstandard_tag: # they match 
                if predicted_tag != "O":
                    counts[predicted_tag]["tp"] = counts[predicted_tag]["tp"] + 1
            else: # they do not match
                if goldstandard_tag != "O": # is this correct?
                    counts[predicted_tag]["fp"] = counts[predicted_tag]["fp"] + 1
                if goldstandard_tag != "O":
                    counts[goldstandard_tag]["fn"] = counts[goldstandard_tag]["fn"] + 1
    
tp = 0
fp = 0
fn = 0

for tag, mydict in counts.items():
    tp = mydict["tp"]
    fp = mydict["fp"]
    fn = mydict["fn"]
precision = tp / (tp+fp)
recall = tp / (tp+fn)

f1 = (2*precision*recall)/(precision+recall)

print("P = " + str(precision))
print("R = " + str(recall))
print("F1 = " + str(f1))
           