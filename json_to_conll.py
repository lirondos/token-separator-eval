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
                print(g)
                print(p)
                g_json = json.loads(g)
                interruptus_tag = None
                for token, predicted_tag in zip(g_json["tokens"], p.split()):
                    if token == "||": # we are dealing with a space
                        if predicted_tag != "O": # the space has a B/I label, we keep the tag
                            interruptus_tag = predicted_tag.split("-")[1]
                        continue # we skip the space
                    else: # we are dealing with a non-space token
                        if predicted_tag != "O": 
                            if interruptus_tag: # if it's not an O and there was an interruptus tag, we assume we are inside an entity
                                writer.writerow([token, "I-" + interruptus_tag])
                                interruptus_tag = None
                                continue
                        writer.writerow([token, predicted_tag])
                        interruptus_tag = None

                        
                writer.writerow([])
                writer.writerow([])

                