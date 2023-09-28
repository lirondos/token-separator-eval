#!/bin/bash
source /home/ealvarezmellado/miniconda3/etc/profile.d/conda.sh
conda activate lrec2024

export JSON_FILE=/home/ealvarezmellado/lrec2024/acl_mapping.json

embeddings=( "bert-beto-bpe"  "bert-beto-bpe-char"  "codeswitch"  "codeswitch-bpe"  "codeswitch-char"  "codeswitch-char-bpe" )

# we run on flair

(
for embedding in "${embeddings[@]}" ; do

for run in {1..10}; do

export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/flair/"$embedding"/run"$run"
export BIO_FILE_DEV="$RUN_DIR"/final_dev.tsv
export BIO_FILE_DEV_AGNOSTIC="$RUN_DIR"/final_dev_agnostic.tsv


export BIO_FILE_TEST="$RUN_DIR"/final_test.tsv
export BIO_FILE_TEST_AGNOSTIC="$RUN_DIR"/final_test_agnostic.tsv

seqscore process --labels BIO --type-map $JSON_FILE BIO_FILE_DEV BIO_FILE_DEV_AGNOSTIC
seqscore process --labels BIO --type-map $JSON_FILE BIO_FILE_TEST BIO_FILE_TEST_AGNOSTIC

done

done
)

(

for run in {1..10}; do

# we run on mbert
export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/mbert/run"$run"
export BIO_FILE_DEV="$RUN_DIR"/dev_predictions.txt
export BIO_FILE_DEV_AGNOSTIC="$RUN_DIR"/dev_predictions_agnostic.txt

export BIO_FILE_TEST="$RUN_DIR"/test_results/test_predictions.txt

export BIO_FILE_TEST_AGNOSTIC="$RUN_DIR"/test_results/test_predictions_agnostic.txt

seqscore process --labels BIO --type-map $JSON_FILE BIO_FILE_DEV BIO_FILE_DEV_AGNOSTIC
seqscore process --labels BIO --type-map $JSON_FILE BIO_FILE_TEST BIO_FILE_TEST_AGNOSTIC

done
)

# we run on beto

(
for run in {1..10}; do

export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/beto/run"$run"

export BIO_FILE_DEV="$RUN_DIR"/dev_predictions.txt
export BIO_FILE_DEV_AGNOSTIC="$RUN_DIR"/dev_predictions_agnostic.txt

export BIO_FILE_TEST="$RUN_DIR"/test_results/test_predictions.txt
export BIO_FILE_TEST_AGNOSTIC="$RUN_DIR"/test_results/test_predictions_agnostic.txt

seqscore process --labels BIO --type-map $JSON_FILE BIO_FILE_DEV BIO_FILE_DEV_AGNOSTIC
seqscore process --labels BIO --type-map $JSON_FILE BIO_FILE_TEST BIO_FILE_TEST_AGNOSTIC
 
done
)