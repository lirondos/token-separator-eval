#!/bin/bash
source /home/ealvarezmellado/miniconda3/etc/profile.d/conda.sh
conda activate lrec2024


(

for run in {1..10}; do

# we run on mbert
export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/mbert/run"$run"


export BIO_FILE_TEST="$RUN_DIR"/test_results/oct2023/test_predictions.txt

export TS_FILE_TEST="$RUN_DIR"/test_results/oct2023/test_predictions_ts.txt


python /home/ealvarezmellado/lrec2024/token-separator-eval/conll_to_ts.py --input $BIO_FILE_TEST --output $TS_FILE_TEST


done
)

# we run on beto

(
for run in {1..10}; do

export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/beto/run"$run"


export BIO_FILE_TEST="$RUN_DIR"/test_results/oct2023/test_predictions.txt
export TS_FILE_TEST="$RUN_DIR"/test_results/oct2023/test_predictions_ts.txt

python /home/ealvarezmellado/lrec2024/token-separator-eval/conll_to_ts.py --input $BIO_FILE_TEST --output $TS_FILE_TEST

done
)