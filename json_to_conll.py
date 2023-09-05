import argparse
from pathlib import Path
import json
import csv

 

parser = argparse.ArgumentParser()
parser.add_argument("--goldstandard", help="path to json", type=str)
parser.add_argument('--predictions', help="path to predictions.txt", type=str)
parser.add_argument("--output", help="path where output file will be stored", type=str)
#parser.add_argument('--is_predictions', action='store_true')

                    
args = parser.parse_args()

goldstandard = Path(args.goldstandard)

with open(args.output, 'w', newline='') as tsvfile:
    writer = csv.writer(tsvfile, delimiter='\t', lineterminator='\n')
    
    if args.predictions:
        predictions = Path(args.predictions)
        with open(goldstandard) as goldstandard_lines, open(predictions) as predictions_lines:
            for g, p in zip(goldstandard_lines, predictions_lines):
                g_json = json.loads(g)
                interruptus_tag = None
                for token, predicted_tag in zip(g_json["tokens"], p.split()):
                    if token.isspace():
                        interruptus_tag = predicted_tag.split("-")[1]
                        continue
                    else:
                        if predicted_tag != "O" and interruptus_tag:
                            writer.writerow([token, "I-" + interruptus_tag])
                        else: #predicted tag is O
                            writer.writerow([token, "O"])
            writer.writerow([])
            writer.writerow([])

                