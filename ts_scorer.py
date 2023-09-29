import argparse
from pathlib import Path
import json
import csv
from collections import defaultdict


def write_to_csv(rows):
    # Workbook is created
    with open(args.csv, 'a', encoding='UTF8', newline='') as f:
        writer = csv.writer(f)

        # write multiple rows
        writer.writerows(rows)
 
def get_p_r_f(tp, fp, fn):
    try:
        precision = tp / (tp+fp)
        recall = tp / (tp+fn)
        f1 = (2*precision*recall)/(precision+recall)
    except:
        print(args.csv, args.goldstandard)
        
    return precision, recall, f1
    
def print_p_r_f1(precision, recall, f1, label):
    print("For label " + label)
    print("P = " + str(precision))
    print("R = " + str(recall))
    print("F1 = " + str(f1))
    
parser = argparse.ArgumentParser()
parser.add_argument("--predicted", help="path to conll file to be transformed", type=str)
parser.add_argument("--goldstandard", help="path where output file will be stored", type=str)
parser.add_argument('--only_tokens', action='store_true')
parser.add_argument('--collapse_entities', action='store_true')
parser.add_argument('--csv', type=str)
parser.add_argument('--seed', type=str)


                    
args = parser.parse_args()

predicted = Path(args.predicted)
goldstandard = Path(args.goldstandard)

counts = defaultdict(lambda: defaultdict(int))

to_ts = []

with open(predicted, "r", encoding="utf-8") as predicted_file, open(goldstandard, "r", encoding="utf-8") as goldstandard_file:
    for i, (predicted_line, goldstandard_line) in enumerate(zip(predicted_file, goldstandard_file)):
        if predicted_line.strip() and goldstandard_line.strip(): # lines are not blank
            predicted_token, predicted_tag = predicted_line.split()
            goldstandard_token, goldstandard_tag = goldstandard_line.split()
            if args.only_tokens and goldstandard_token == "||":
                continue
            if goldstandard_token != predicted_token:
                print("Mismatch between files in line " + str(i))
                print("Goldstandard: " + goldstandard_token)
                print("Prediction: " + predicted_token)
                break
            if args.collapse_entities: # lenient version
                if predicted_tag != "O" and goldstandard_tag != "O": # they match in the lenient version
                    counts["ENT"]["tp"] = counts["ENT"]["tp"] + 1
                else: # they do not match
                    if goldstandard_tag == "O" and predicted_tag != "O": # 
                        counts["ENT"]["fp"] = counts["ENT"]["fp"] + 1
                    if predicted_tag == "O" and goldstandard_tag != "O":
                        counts["ENT"]["fn"] = counts["ENT"]["fn"] + 1 

            else: # exact entity match
                if predicted_tag == goldstandard_tag: # they match 
                    if predicted_tag != "O":
                        counts[predicted_tag]["tp"] = counts[predicted_tag]["tp"] + 1
                else: # they do not match
                    if predicted_tag != "O": # 
                        counts[predicted_tag]["fp"] = counts[predicted_tag]["fp"] + 1
                    if goldstandard_tag != "O":
                        counts[goldstandard_tag]["fn"] = counts[goldstandard_tag]["fn"] + 1
        
tp = 0
fp = 0
fn = 0

print(counts)
rows = []
for tag, mydict in counts.items():
    p, r, f1 = get_p_r_f(mydict["tp"],mydict["fp"],mydict["fn"])
    #print_p_r_f1(p,r,f1,tag)

    rows.append([args.seed, tag, p, r, f1])

    tp = tp + mydict["tp"]
    fp = fp + mydict["fp"]
    fn = fn + mydict["fn"]

p, r, f1 = get_p_r_f(tp, fp, fn)
rows.append([args.seed, "ALL", p, r, f1])
write_to_csv(rows)    



           