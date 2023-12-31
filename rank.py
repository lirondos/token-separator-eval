import argparse
from pathlib import Path
import json
import csv
import pandas as pd
from collections import defaultdict
from openpyxl import Workbook


EXCEL_DEV = "/home/ealvarezmellado/lrec2024/token-separator-eval/dev.xlsx"
EXCEL_TEST = "/home/ealvarezmellado/lrec2024/token-separator-eval/test.xlsx"

parser = argparse.ArgumentParser()
parser.add_argument("--folder", help="path to folder with evaluation", type=str)
#parser.add_argument('--is_predictions', action='store_true')

                    
args = parser.parse_args()

wb_dev = Workbook()
wb_test = Workbook()

wb_test.save(EXCEL_TEST)
wb_dev.save(EXCEL_DEV)



dev = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: None)))
test = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: None)))



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
        f = df["F1_ENT"].mean()
    else:
        p = df["PRECISION_ALL"].mean()
        r = df["RECALL_ALL"].mean()
        f = df["F1_ALL"].mean()
    if split == "dev":
        dev[metric][model]["precision"] = p
        dev[metric][model]["recall"] = r
        dev[metric][model]["f1"] = f
    else:
        test[metric][model]["precision"] = p
        test[metric][model]["recall"] = r
        test[metric][model]["f1"] = f
for metric,model in dev.items():
    print(metric)
    print(dict(model))
    with pd.ExcelWriter(EXCEL_DEV, mode="a", engine='openpyxl') as writer:
        df = pd.DataFrame.from_dict(dict(model)).transpose()
        df.to_excel(writer, sheet_name=metric)
        
for metric,model in test.items():
    print(metric)
    print(dict(model))
    with pd.ExcelWriter(EXCEL_TEST, mode="a", engine='openpyxl') as writer:
        df = pd.DataFrame.from_dict(dict(model)).transpose()
        df.to_excel(writer, sheet_name=metric)
           