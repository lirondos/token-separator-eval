#!/bin/bash
source /home/ealvarezmellado/miniconda3/etc/profile.d/conda.sh
conda activate lrec2024

export JSON_FILE=/home/ealvarezmellado/lrec2024/acl_mapping.json

(

for run in {1..10}; do

# we run on mbert
export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/mbert/run"$run"

export BIO_FILE_TEST="$RUN_DIR"/test_results/oct2023/test_predictions.txt
export BIO_FILE_TEST_REPAIRED="$RUN_DIR"/test_results/oct2023/test_predictions_repaired.txt
export BIO_FILE_TEST_AGNOSTIC="$RUN_DIR"/test_results/oct2023/test_predictions_agnostic.txt

seqscore repair --labels BIO --repair-method conlleval $BIO_FILE_TEST $BIO_FILE_TEST_REPAIRED && seqscore process --labels BIO --type-map $JSON_FILE $BIO_FILE_TEST_REPAIRED $BIO_FILE_TEST_AGNOSTIC

done
)

# we run on beto

(
for run in {1..10}; do

export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/beto/run"$run"

export BIO_FILE_TEST="$RUN_DIR"/test_results/oct2023/test_predictions.txt
export BIO_FILE_TEST_REPAIRED="$RUN_DIR"/test_results/oct2023/test_predictions_repaired.txt
export BIO_FILE_TEST_AGNOSTIC="$RUN_DIR"/test_results/oct2023/test_predictions_agnostic.txt


seqscore repair --labels BIO --repair-method conlleval $BIO_FILE_TEST $BIO_FILE_TEST_REPAIRED && seqscore process --labels BIO --type-map $JSON_FILE $BIO_FILE_TEST_REPAIRED $BIO_FILE_TEST_AGNOSTIC
 
done
)