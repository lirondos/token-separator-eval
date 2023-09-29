#!/bin/bash
source /home/ealvarezmellado/miniconda3/etc/profile.d/conda.sh
conda activate lrec2024

export EVALUATION_DIR=/home/ealvarezmellado/lrec2024/token-separator-eval/evaluation

mkdir $EVALUATION_DIR

export DATA_FOLDER=/home/ealvarezmellado/adobo/corpus/
export GOLDSTANDARD_DEV="$DATA_FOLDER"/dev.conll
export GOLDSTANDARD_TEST="$DATA_FOLDER"/test.conll
export GOLDSTANDARD_DEV_TS="$DATA_FOLDER"/dev_ts.conll
export GOLDSTANDARD_TEST_TS="$DATA_FOLDER"/test_ts.conll
export GOLDSTANDARD_DEV_AGNOSTIC="$DATA_FOLDER"/dev_agnostic.conll
export GOLDSTANDARD_TEST_AGNOSTIC="$DATA_FOLDER"/test_agnostic.conll


embeddings=( "bert-beto-bpe"  "bert-beto-bpe-char"  "codeswitch"  "codeswitch-bpe"  "codeswitch-char"  "codeswitch-char-bpe" )

# we run on flair


(
for embedding in "${embeddings[@]}" ; do


export CSV_SPAN_DEV="$EVALUATION_DIR"/"$embedding"_span_dev.csv
export CSV_SPAN_TEST="$EVALUATION_DIR"/"$embedding"_span_test.csv

export CSV_TS_DEV="$EVALUATION_DIR"/"$embedding"_ts_dev.csv
export CSV_TS_TEST="$EVALUATION_DIR"/"$embedding"_ts_test.csv

export CSV_TS_TOK_DEV="$EVALUATION_DIR"/"$embedding"_ts_tok_dev.csv
export CSV_TS_TOK_TEST="$EVALUATION_DIR"/"$embedding"_ts_tok_test.csv


export CSV_SPAN_AGNOSTIC_DEV="$EVALUATION_DIR"/"$embedding"_span_agnostic_dev.csv
export CSV_SPAN_AGNOSTIC_TEST="$EVALUATION_DIR"/"$embedding"_span_agnostic_test.csv

export CSV_TS_AGNOSTIC_DEV="$EVALUATION_DIR"/"$embedding"_ts_agnostic_dev.csv
export CSV_TS_AGNOSTIC_TEST="$EVALUATION_DIR"/"$embedding"_ts_agnostic_test.csv

export CSV_TS_TOK_AGNOSTIC_DEV="$EVALUATION_DIR"/"$embedding"_ts_tok_agnostic_dev.csv
export CSV_TS_TOK_AGNOSTIC_TEST="$EVALUATION_DIR"/"$embedding"_ts_tok_agnostic_test.csv


for run in {1..10}; do


export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/flair/"$embedding"/run"$run"


export PREDICTED_DEV="$RUN_DIR"/final_dev.tsv
export PREDICTED_TEST="$RUN_DIR"/final_test.tsv


export PREDICTED_DEV_TS="$RUN_DIR"/final_dev_ts.tsv
export PREDICTED_TEST_TS="$RUN_DIR"/final_test_ts.tsv

export PREDICTED_DEV_AGNOSTIC="$RUN_DIR"/final_dev_agnostic.tsv
export PREDICTED_TEST_AGNOSTIC="$RUN_DIR"/final_test_agnostic.tsv

# Span evaluation
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_DEV --predicted $PREDICTED_DEV --seed $run --csv $CSV_SPAN_DEV
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_TEST --predicted $PREDICTED_TEST --seed $run --csv $CSV_SPAN_TEST

# TS evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_DEV --seed $run 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_TEST --seed $run 

# TS evaluation only tokens
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_TOK_DEV --seed $run --only_tokens 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_TOK_TEST --seed $run --only_tokens 



## ENTITY AGNOSTIC EVALUATION


# Span evaluation
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_DEV_AGNOSTIC --predicted $PREDICTED_DEV_AGNOSTIC --seed $run --csv $CSV_SPAN_AGNOSTIC_DEV
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_TEST_AGNOSTIC --predicted $PREDICTED_TEST_AGNOSTIC --seed $run --csv $CSV_SPAN_AGNOSTIC_TEST

# TS evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_AGNOSTIC_DEV --seed $run --collapse_entities 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_AGNOSTIC_TEST --seed $run --collapse_entities 

# TS evaluation only tokens
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_TOK_AGNOSTIC_DEV --seed $run --only_tokens --collapse_entities 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_TOK_AGNOSTIC_TEST --seed $run --only_tokens --collapse_entities 



done

done
)

# we evaluate beto


export CSV_SPAN_DEV="$EVALUATION_DIR"/beto_span_dev.csv
export CSV_SPAN_TEST="$EVALUATION_DIR"/beto_span_test.csv

export CSV_TS_DEV="$EVALUATION_DIR"/beto_ts_dev.csv
export CSV_TS_TEST="$EVALUATION_DIR"/beto_ts_test.csv

export CSV_TS_TOK_DEV="$EVALUATION_DIR"/beto_ts_tok_dev.csv
export CSV_TS_TOK_TEST="$EVALUATION_DIR"/beto_ts_tok_test.csv


export CSV_SPAN_AGNOSTIC_DEV="$EVALUATION_DIR"/beto_span_agnostic_dev.csv
export CSV_SPAN_AGNOSTIC_TEST="$EVALUATION_DIR"/beto_span_agnostic_test.csv

export CSV_TS_AGNOSTIC_DEV="$EVALUATION_DIR"/beto_ts_agnostic_dev.csv
export CSV_TS_AGNOSTIC_TEST="$EVALUATION_DIR"/beto_ts_agnostic_test.csv

export CSV_TS_TOK_AGNOSTIC_DEV="$EVALUATION_DIR"/beto_ts_tok_agnostic_dev.csv
export CSV_TS_TOK_AGNOSTIC_TEST="$EVALUATION_DIR"/beto_ts_tok_agnostic_test.csv

(
for run in {1..10}; do

export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/beto/run"$run"

export PREDICTED_DEV="$RUN_DIR"/dev_predictions.txt
export PREDICTED_TEST="$RUN_DIR"/test_results/test_predictions.txt

export PREDICTED_DEV_TS="$RUN_DIR"/dev_predictions_ts.txt
export PREDICTED_TEST_TS="$RUN_DIR"/test_results/test_predictions_ts.txt

export PREDICTED_DEV_AGNOSTIC="$RUN_DIR"/dev_predictions_agnostic.txt
export PREDICTED_TEST_AGNOSTIC="$RUN_DIR"/test_results/test_predictions_agnostic.txt

# Span evaluation
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_DEV --predicted $PREDICTED_DEV --seed $run --csv $CSV_SPAN_DEV
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_TEST --predicted $PREDICTED_TEST --seed $run --csv $CSV_SPAN_TEST

# TS evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_DEV --seed $run 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_TEST --seed $run 

# TS evaluation only tokens
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_TOK_DEV --seed $run --only_tokens 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_TOK_TEST --seed $run --only_tokens 



## ENTITY AGNOSTIC EVALUATION


# Span evaluation
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_DEV_AGNOSTIC --predicted $PREDICTED_DEV_AGNOSTIC --seed $run --csv $CSV_SPAN_AGNOSTIC_DEV
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_TEST_AGNOSTIC --predicted $PREDICTED_TEST_AGNOSTIC --seed $run --csv $CSV_SPAN_AGNOSTIC_TEST

# TS evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_AGNOSTIC_DEV --seed $run --collapse_entities 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_AGNOSTIC_TEST --seed $run --collapse_entities 

# TS evaluation only tokens
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_TOK_AGNOSTIC_DEV --seed $run --only_tokens --collapse_entities 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_TOK_AGNOSTIC_TEST --seed $run --only_tokens --collapse_entities 


)

# we evaluate mbert

export CSV_SPAN_DEV="$EVALUATION_DIR"/mbert_span_dev.csv
export CSV_SPAN_TEST="$EVALUATION_DIR"/mbert_span_test.csv

export CSV_TS_DEV="$EVALUATION_DIR"/mbert_ts_dev.csv
export CSV_TS_TEST="$EVALUATION_DIR"/mbert_ts_test.csv

export CSV_TS_TOK_DEV="$EVALUATION_DIR"/mbert_ts_tok_dev.csv
export CSV_TS_TOK_TEST="$EVALUATION_DIR"/mbert_ts_tok_test.csv


export CSV_SPAN_AGNOSTIC_DEV="$EVALUATION_DIR"/mbert_span_agnostic_dev.csv
export CSV_SPAN_AGNOSTIC_TEST="$EVALUATION_DIR"/mbert_span_agnostic_test.csv

export CSV_TS_AGNOSTIC_DEV="$EVALUATION_DIR"/mbert_ts_agnostic_dev.csv
export CSV_TS_AGNOSTIC_TEST="$EVALUATION_DIR"/mbert_ts_agnostic_test.csv

export CSV_TS_TOK_AGNOSTIC_DEV="$EVALUATION_DIR"/mbert_ts_tok_agnostic_dev.csv
export CSV_TS_TOK_AGNOSTIC_TEST="$EVALUATION_DIR"/mbert_ts_tok_agnostic_test.csv


(
for run in {1..10}; do

export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/mbert/run"$run"

export PREDICTED_DEV="$RUN_DIR"/dev_predictions.txt
export PREDICTED_TEST="$RUN_DIR"/test_results/test_predictions.txt

export PREDICTED_DEV_TS="$RUN_DIR"/dev_predictions_ts.txt
export PREDICTED_TEST_TS="$RUN_DIR"/test_results/test_predictions_ts.txt

export PREDICTED_DEV_AGNOSTIC="$RUN_DIR"/dev_predictions_agnostic.txt
export PREDICTED_TEST_AGNOSTIC="$RUN_DIR"/test_results/test_predictions_agnostic.txt

# Span evaluation
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_DEV --predicted $PREDICTED_DEV --seed $run --csv $CSV_SPAN_DEV
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_TEST --predicted $PREDICTED_TEST --seed $run --csv $CSV_SPAN_TEST

# TS evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_DEV --seed $run 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_TEST --seed $run 

# TS evaluation only tokens
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_TOK_DEV --seed $run --only_tokens 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_TOK_TEST --seed $run --only_tokens 



## ENTITY AGNOSTIC EVALUATION


# Span evaluation
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_DEV_AGNOSTIC --predicted $PREDICTED_DEV_AGNOSTIC --seed $run --csv $CSV_SPAN_AGNOSTIC_DEV
python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $GOLDSTANDARD_TEST_AGNOSTIC --predicted $PREDICTED_TEST_AGNOSTIC --seed $run --csv $CSV_SPAN_AGNOSTIC_TEST

# TS evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_AGNOSTIC_DEV --seed $run --collapse_entities 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_AGNOSTIC_TEST --seed $run --collapse_entities 

# TS evaluation only tokens
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_DEV_TS --csv $CSV_TS_TOK_AGNOSTIC_DEV --seed $run --only_tokens --collapse_entities 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TEST_TS --csv $CSV_TS_TOK_AGNOSTIC_TEST --seed $run --only_tokens --collapse_entities run
)




