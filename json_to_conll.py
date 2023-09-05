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
    
    for line in f:
        if args.predictions:
            predictions = Path(args.predictions)
            with open(goldstandard) as goldstandard_lines, open(predictions) as predictions_lines:
                for g, p in zip(goldstandard_lines, predictions_lines):
                    g_json = json.loads(g)
                    for token, predicted_tag in zip(g_json["tokens"], p.split()):
                        writer.writerow([token, tag])
                writer.writerow([])
                