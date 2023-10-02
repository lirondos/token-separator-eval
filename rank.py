import argparse
from pathlib import Path
import json
import csv
import pandas as pd
 

parser = argparse.ArgumentParser()
parser.add_argument("--folder", help="path to folder with evaluation", type=str)
#parser.add_argument('--is_predictions', action='store_true')

                    
args = parser.parse_args()

test = dict()
dev = dict()

files = Path(args.folder).glob('*')
for file in files:
    file_name = file.stem()
    model, rest = file_name.split('_', 1)
    metric, split = rest.rsplit('_', 1)
    df = pd.read_csv(files, sep=",", header=0)
    if "agnostic" in metric:
        p = df["PRECISION_ENT"].mean()
        r = df["RECALL_ENT"].mean()
        f = df["RECALL_ENT"].mean()
    else:
        p = df["PRECISION_ALL"].mean()
        r = df["RECALL_ALL"].mean()
        f = df["RECALL_ALL"].mean()
    if split == "dev":
        dev[metric][model]=(p,r,f)
    else:
        test[metric][model]=(p,r,f)
for split, metric in dev.items():
    for model, numbers in metric.items():
        p, r, f = numbers
        mydic["precision"] = p
        mydic["recall"] = r
        mydic["f1"] = f
    with pd.ExcelWriter("dev.xlsx", engine="openpyxl", mode="a") as writer:
        pd.Dataframe.from_dict(mydict).to_excel(writer, sheet_name=metric))
           