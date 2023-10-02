import argparse
import csv
import seqscore
from seqscore.conll import (
    SUPPORTED_SCORE_FORMATS,
    ingest_conll_file,
    repair_conll_file,
    score_conll_files,
    validate_conll_file,
    write_docs_using_encoding,
    compute_scores,
    format_output_conlleval,
    format_output_table
)

parser = argparse.ArgumentParser(description='evaluate using seqscore')
parser.add_argument('--reference', type=str, help='Fichero de referencia')
parser.add_argument('--predicted', type=str, help='Fichero con la predicción')
parser.add_argument('--seed', type=int, help='Seed')
parser.add_argument('--csv', type=str, help='Fichero csv con la salida')

args = parser.parse_args()


def write_to_csv(rows):
    # Workbook is created
    with open(args.csv, 'a', encoding='UTF8', newline='') as f:
        writer = csv.writer(f)

        # write multiple rows
        writer.writerows(rows)
    
if __name__ == "__main__":
    repair_method = "conlleval"    
    file_encoding = "UTF-8"
    mention_encoding_name = "BIO"
    pred_docs = ingest_conll_file(
            args.predicted,
            mention_encoding_name,
            file_encoding,  
            repair = repair_method,
            ignore_document_boundaries= False,
            ignore_comment_lines= True
        )
        
    ref_docs = ingest_conll_file(
        args.reference,
        mention_encoding_name,
        file_encoding,
        repair = repair_method,
        ignore_document_boundaries= False,
        ignore_comment_lines= True
    )

if __name__ == "__main__":    
    class_scores, acc_scores = compute_scores(pred_docs, ref_docs)
    results = format_output_table(class_scores, False)[1]
    row = [args.seed]
    for result in results:
        row.extend([str(result[1]), str(result[2]), str(result[3])])
    write_to_csv([row])
    """
    print(class_scores.precision)
    print(class_scores.recall)
    print(class_scores.f1)
    print(acc_scores.accuracy)
    """


