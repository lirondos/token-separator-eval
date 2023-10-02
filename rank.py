import argparse
from pathlib import Path
import json
import csv
import pandas as pd
from collections import defaultdict
 

parser = argparse.ArgumentParser()
parser.add_argument("--folder", help="path to folder with evaluation", type=str)
#parser.add_argument('--is_predictions', action='store_true')

                    
args = parser.parse_args()

test = defaultdict(lambda: defaultdict(lambda:None))
dev = defaultdict(lambda: defaultdict(lambda: None))

files = Path(args.folder).glob('*')
for file in files:
    file_name = file.stem
    model, rest = file_name.split('_', 1)
    metric, split = rest.rsplit('_', 1)
    df = pd.read_csv(file, sep=",", header=0)
    print(df)
    if "agnostic" in metric:
        p = df["PRECISION_ENT"].mean()
        r = df["RECALL_ENT"].mean()
        f = df["RECALL_ENT"].mean()
    else:
        p = df["PRECISION_ALL"].mean()
        r = df["RECALL_ALL"].mean()
        f = df["RECALL_ALL"].mean()
    if split == "dev":
        dev[metric][model]["precision"] = p
        dev[metric][model]["recall"] = recall
        dev[metric][model]["f1"] = f1
    else:
        test[metric][model]["precision"] = p
        test[metric][model]["recall"] = recall
        test[metric][model]["f1"] = f1
for metric,model in dev.items():
    with pd.ExcelWriter("dev.xlsx", engine="openpyxl", mode="a") as writer:
        pd.Dataframe.from_dict(mydict).to_excel(writer, sheet_name=metric)
           