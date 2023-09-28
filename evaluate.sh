#!/bin/bash
source ~/miniconda3/etc/profile.d/conda.sh
conda activate lrec2024

export EVALUATION_DIR=/home/ealvarezmellado/lrec2024/token-separator-eval/evaluation

mkdir $EVALUATION_DIR

embeddings=( "bert-beto-bpe"  "bert-beto-bpe-char"  "codeswitch"  "codeswitch-bpe"  "codeswitch-char"  "codeswitch-char-bpe" )

# we run on flair


(
for embedding in "${embeddings[@]}" ; do


export CSV_FILE_DEV "$EVALUATION_DIR"/"$embedding"_dev.csv

export CSV_FILE_TEST "$EVALUATION_DIR"/"$embedding"_test.csv

echo SEED,TYPE,PRECISION,RECALL,F1 > $CSV_FILE_DEV
echo SEED,TYPE,PRECISION,RECALL,F1 > $CSV_FILE_TEST

for run in {1..10}; do


export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/flair/"$embedding"/run"$run"

export TS_FILE_DEV="$RUN_DIR"/final_dev_ts.tsv

export TS_FILE_TEST="$RUN_DIR"/final_test_ts.tsv


python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_DEV --goldstandard /home/ealvarezmellado/adobo/corpus/dev_ts.conll --only_tokens --csv $CSV_FILE_DEV --seed $run

python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_TEST --goldstandard /home/ealvarezmellado/adobo/corpus/test_ts.conll --only_tokens --csv $CSV_FILE_TEST --seed $run

python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_DEV --goldstandard /home/ealvarezmellado/adobo/corpus/dev_ts.conll --only_tokens --collapse_entities --csv $CSV_FILE_DEV --seed $run

python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_TEST --goldstandard /home/ealvarezmellado/adobo/corpus/test_ts.conll --only_tokens --collapse_entities --csv $CSV_FILE_TEST --seed $run


done

done
)

# we evaluate beto

export CSV_FILE_DEV="$EVALUATION_DIR"/beto_dev.csv

export CSV_FILE_TEST="$EVALUATION_DIR"/beto_test.csv

echo SEED,TYPE,PRECISION,RECALL,F1 > $CSV_FILE_DEV
echo SEED,TYPE,PRECISION,RECALL,F1 > $CSV_FILE_TEST

(
for run in {1..10}; do

export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/beto/run"$run"

export TS_FILE_DEV="$RUN_DIR"/dev_predictions_ts.txt

export TS_FILE_TEST="$RUN_DIR"/test_results/test_predictions_ts.txt


python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_DEV --goldstandard /home/ealvarezmellado/adobo/corpus/dev_ts.conll --only_tokens --csv $CSV_FILE --model $MODEL --seed $run

python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_TEST --goldstandard /home/ealvarezmellado/adobo/corpus/test_ts.conll --only_tokens --csv $CSV_FILE --model $MODEL --seed $run

python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_DEV --goldstandard /home/ealvarezmellado/adobo/corpus/dev_ts.conll --only_tokens --collapse_entities --csv $CSV_FILE --model $MODEL --seed $run

python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_TEST --goldstandard /home/ealvarezmellado/adobo/corpus/test_ts.conll --only_tokens --collapse_entities --csv $CSV_FILE --model $MODEL --seed $run
)

# we evaluate mbert

export CSV_FILE_DEV="$EVALUATION_DIR"/mbert_dev.csv

export CSV_FILE_TEST="$EVALUATION_DIR"/mbert_test.csv

echo SEED,TYPE,PRECISION,RECALL,F1 > $CSV_FILE_DEV
echo SEED,TYPE,PRECISION,RECALL,F1 > $CSV_FILE_TEST

(
for run in {1..10}; do

export RUN_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/mbert/run"$run"

export TS_FILE_DEV="$RUN_DIR"/dev_predictions_ts.txt

export TS_FILE_TEST="$RUN_DIR"/test_results/test_predictions_ts.txt


python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_DEV --goldstandard /home/ealvarezmellado/adobo/corpus/dev_ts.conll --only_tokens --csv $CSV_FILE_DEV --seed $run

python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_TEST --goldstandard /home/ealvarezmellado/adobo/corpus/test_ts.conll --only_tokens --csv $CSV_FILE_TEST --seed $run

python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_DEV --goldstandard /home/ealvarezmellado/adobo/corpus/dev_ts.conll --only_tokens --collapse_entities --csv $CSV_FILE_DEV --seed $run

python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $TS_FILE_TEST --goldstandard /home/ealvarezmellado/adobo/corpus/test_ts.conll --only_tokens --collapse_entities --csv $CSV_FILE_TEST --seed $run
)




