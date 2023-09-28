#!/bin/bash
source /home/ealvarezmellado/miniconda3/etc/profile.d/conda.sh
conda activate lrec2024


embedding="bert-beto-bpe"
run ="1"

export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/flair/"$embedding"/run"$run"
export BIO_FILE_TEST="$RUN_DIR"/final_dev.tsv
export BIO_FILE_DEV="$RUN_DIR"/final_test.tsv

export TS_FILE_TEST="$RUN_DIR"/final_dev_ts.tsv
export TS_FILE_DEV="$RUN_DIR"/final_test_ts.tsv

python /home/ealvarezmellado/lrec2024/token-separator-eval/conll_to_ts.py --input BIO_FILE_TEST --output TS_FILE_TEST --is_flair

python /home/ealvarezmellado/lrec2024/token-separator-eval/conll_to_ts.py --input BIO_FILE_DEV --output TS_FILE_DEV --is_flair
export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/mbert/run"$run"
export BIO_FILE_TEST="$RUN_DIR"/dev_predictions.txt
export BIO_FILE_DEV="$RUN_DIR"/final_test.tsv

export TS_FILE_TEST="$RUN_DIR"/test_results/test_predictions.txt
export TS_FILE_DEV="$RUN_DIR"/test_results/test_predictions_ts.txt

python /home/ealvarezmellado/lrec2024/token-separator-eval/conll_to_ts.py --input BIO_FILE_TEST --output TS_FILE_TEST

python /home/ealvarezmellado/lrec2024/token-separator-eval/conll_to_ts.py --input BIO_FILE_DEV --output TS_FILE_DEV 

export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/beto/run"$run"
export BIO_FILE_TEST="$RUN_DIR"/dev_predictions.txt
export BIO_FILE_DEV="$RUN_DIR"/final_test.tsv

export TS_FILE_TEST="$RUN_DIR"/test_results/test_predictions.txt
export TS_FILE_DEV="$RUN_DIR"/test_results/test_predictions_ts.txt

python /home/ealvarezmellado/lrec2024/token-separator-eval/conll_to_ts.py --input BIO_FILE_TEST --output TS_FILE_TEST

python /home/ealvarezmellado/lrec2024/token-separator-eval/conll_to_ts.py --input BIO_FILE_DEV --output TS_FILE_DEV 
