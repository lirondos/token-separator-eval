#!/bin/bash
source /home/ealvarezmellado/miniconda3/etc/profile.d/conda.sh
conda activate lrec2024

export run=0
export RESULTS_DIR=/home/ealvarezmellado/lrec2024/token-separator-eval/wnut_17_conll/results
mkdir $RESULTS_DIR

export CSV_SPAN_DEV="$RESULTS_DIR"/span_dev.csv
export CSV_SPAN_TEST="$RESULTS_DIR"/span_test.csv
export CSV_SPAN_AGNOSTIC_DEV="$RESULTS_DIR"/span_agnostic_dev.csv
export CSV_SPAN_AGNOSTIC_TEST="$RESULTS_DIR"/span_agnostic_test.csv
export CSV_TS_DEV="$RESULTS_DIR"/ts_dev.csv
export CSV_TS_TEST="$RESULTS_DIR"/ts_test.csv
export CSV_TS_TOK_DEV="$RESULTS_DIR"/ts_tok_dev.csv
export CSV_TS_TOK_TEST="$RESULTS_DIR"/ts_tok_test.csv
export CSV_TS_AGNOSTIC_DEV="$RESULTS_DIR"/ts_agnostic_dev.csv
export CSV_TS_AGNOSTIC_TEST="$RESULTS_DIR"/ts_agnostic_test.csv
export CSV_TS_AGNOSTIC_TOK_DEV="$RESULTS_DIR"/ts_agnostic_tok_dev.csv
export CSV_TS_AGNOSTIC_TOK_TEST="$RESULTS_DIR"/ts_agnostic_tok_test.csv



export GOLDSTANDARD_DIR=/home/ealvarezmellado/lrec2024/token-separator-eval/wnut_17_conll
export GOLDSTANDARD_SPANS_DEV="$GOLDSTANDARD_DIR"/dev.txt
export GOLDSTANDARD_SPANS_AGNOSTIC_DEV="$GOLDSTANDARD_DIR"/dev_agnostic.txt
export GOLDSTANDARD_TS_DEV="$GOLDSTANDARD_DIR"/wnut_17_conll_ts/dev.txt

export GOLDSTANDARD_SPANS_TEST="$GOLDSTANDARD_DIR"/test.txt
export GOLDSTANDARD_SPANS_AGNOSTIC_TEST="$GOLDSTANDARD_DIR"/test_agnostic.txt
export GOLDSTANDARD_TS_TEST="$GOLDSTANDARD_DIR"/wnut_17_conll_ts/test.txt

# Evaluation trained without bars
export EVALUATION_DIR=/home/ealvarezmellado/lrec2024/deberta-json-out
export PREDICTED_SPANS_DEV="$EVALUATION_DIR"/predictions_conll_dev.txt
export PREDICTED_SPANS_AGNOSTIC_DEV="$EVALUATION_DIR"/predictions_conll_agnostic_dev.txt
export PREDICTED_TS_DEV="$EVALUATION_DIR"/predictions_conll_bar_dev.txt

export PREDICTED_SPANS_TEST="$EVALUATION_DIR"/predictions_conll_test.txt
export PREDICTED_SPANS_AGNOSTIC_TEST="$EVALUATION_DIR"/predictions_conll_agnostic_test.txt
export PREDICTED_TS_TEST="$EVALUATION_DIR"/predictions_conll_bar_test.txt

python /home/ealvarezmellado/lrec2024/token-separator-eval/evaluate_spans.py --reference $GOLDSTANDARD_SPANS_DEV --predicted $PREDICTED_SPANS_DEV --seed $run --csv $CSV_SPAN_DEV
python /home/ealvarezmellado/lrec2024/token-separator-eval/evaluate_spans.py --reference $GOLDSTANDARD_SPANS_TEST --predicted $PREDICTED_SPANS_TEST --seed $run --csv $CSV_SPAN_TEST

# TS evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_DEV --goldstandard $GOLDSTANDARD_TS_DEV --csv $CSV_TS_DEV --seed $run 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_TEST --goldstandard $GOLDSTANDARD_TS_TEST --csv $CSV_TS_TEST --seed $run 

# TS evaluation only tokens
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_DEV_TS --goldstandard $GOLDSTANDARD_TS_DEV --csv $CSV_TS_TOK_DEV --seed $run --only_tokens 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TS_TEST --csv $CSV_TS_TOK_TEST --seed $run --only_tokens 

# AGNOSTIC

# Span evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/evaluate_spans.py --reference $GOLDSTANDARD_DEV_AGNOSTIC --predicted $PREDICTED_DEV_AGNOSTIC --seed $run --csv $CSV_SPAN_AGNOSTIC_DEV
python /home/ealvarezmellado/lrec2024/token-separator-eval/evaluate_spans.py --reference $GOLDSTANDARD_TEST_AGNOSTIC --predicted $PREDICTED_TEST_AGNOSTIC --seed $run --csv $CSV_SPAN_AGNOSTIC_TEST

# TS evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_DEV --goldstandard $GOLDSTANDARD_TS_DEV --csv $CSV_TS_AGNOSTIC_DEV --seed $run --collapse_entities 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TS_TEST --csv $CSV_TS_AGNOSTIC_TEST --seed $run --collapse_entities 

# TS evaluation only tokens
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_DEV --goldstandard $GOLDSTANDARD_TS_DEV --csv $CSV_TS_AGNOSTIC_TOK_DEV --seed $run --only_tokens --collapse_entities 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TEST_TS --goldstandard $GOLDSTANDARD_TS_TEST --csv $CSV_TS_AGNOSTIC_TOK_TEST --seed $run --only_tokens --collapse_entities   

#######################################################################
#######################################################################
#######################################################################
#######################################################################
#######################################################################
#######################################################################

# Evaluation trained with bars

export RESULTS_DIR=/home/ealvarezmellado/lrec2024/token-separator-eval/wnut_17_conll/results
export CSV_SPAN_DEV="$RESULTS_DIR"/span_dev_bar.csv
export CSV_SPAN_TEST="$RESULTS_DIR"/span_test_bar.csv
export CSV_SPAN_AGNOSTIC_DEV="$RESULTS_DIR"/span_agnostic_dev_bar.csv
export CSV_SPAN_AGNOSTIC_TEST="$RESULTS_DIR"/span_agnostic_test_bar.csv
export CSV_TS_DEV="$RESULTS_DIR"/ts_dev_bar.csv
export CSV_TS_TEST="$RESULTS_DIR"/ts_test_bar.csv
export CSV_TS_TOK_DEV="$RESULTS_DIR"/ts_tok_dev_bar.csv
export CSV_TS_TOK_TEST="$RESULTS_DIR"/ts_tok_test_bar.csv
export CSV_TS_AGNOSTIC_DEV="$RESULTS_DIR"/ts_agnostic_dev_bar.csv
export CSV_TS_AGNOSTIC_TEST="$RESULTS_DIR"/ts_agnostic_test_bar.csv
export CSV_TS_AGNOSTIC_TOK_DEV="$RESULTS_DIR"/ts_agnostic_tok_dev_bar.csv
export CSV_TS_AGNOSTIC_TOK_TEST="$RESULTS_DIR"/ts_agnostic_tok_test_bar.csv




# Evaluation trained without bars
export EVALUATION_DIR=/home/ealvarezmellado/lrec2024/deberta-json-bar-out
export PREDICTED_SPANS_DEV="$EVALUATION_DIR"/predictions_conll_dev.txt
export PREDICTED_SPANS_AGNOSTIC_DEV="$EVALUATION_DIR"/predictions_conll_agnostic_dev.txt
export PREDICTED_TS_DEV="$EVALUATION_DIR"/predictions_conll_bar_dev.txt

export PREDICTED_SPANS_TEST="$EVALUATION_DIR"/predictions_conll_test.txt
export PREDICTED_SPANS_AGNOSTIC_TEST="$EVALUATION_DIR"/predictions_conll_agnostic_test.txt
export PREDICTED_TS_TEST="$EVALUATION_DIR"/predictions_conll_bar_test.txt

python /home/ealvarezmellado/lrec2024/token-separator-eval/evaluate_spans.py --reference $GOLDSTANDARD_SPANS_DEV --predicted $PREDICTED_SPANS_DEV --seed $run --csv $CSV_SPAN_DEV
python /home/ealvarezmellado/lrec2024/token-separator-eval/evaluate_spans.py --reference $GOLDSTANDARD_SPANS_TEST --predicted $PREDICTED_SPANS_TEST --seed $run --csv $CSV_SPAN_TEST

# TS evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_DEV --goldstandard $GOLDSTANDARD_TS_DEV --csv $CSV_TS_DEV --seed $run 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_TEST --goldstandard $GOLDSTANDARD_TS_TEST --csv $CSV_TS_TEST --seed $run 

# TS evaluation only tokens
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_DEV --goldstandard $GOLDSTANDARD_TS_DEV --csv $CSV_TS_TOK_DEV --seed $run --only_tokens 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_TEST --goldstandard $GOLDSTANDARD_TS_TEST --csv $CSV_TS_TOK_TEST --seed $run --only_tokens 

# AGNOSTIC

# Span evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/evaluate_spans.py --reference $GOLDSTANDARD_SPANS_AGNOSTIC_DEV --predicted $PREDICTED_SPANS_AGNOSTIC_DEV --seed $run --csv $CSV_SPAN_AGNOSTIC_DEV
python /home/ealvarezmellado/lrec2024/token-separator-eval/evaluate_spans.py --reference $GOLDSTANDARD_SPANS_AGNOSTIC_TEST --predicted $PREDICTED_SPANS_AGNOSTIC_TEST --seed $run --csv $CSV_SPAN_AGNOSTIC_TEST

# TS evaluation
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_DEV --goldstandard $GOLDSTANDARD_TS_DEV --csv $CSV_TS_AGNOSTIC_DEV --seed $run --collapse_entities 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_TEST --goldstandard $GOLDSTANDARD_TS_TEST --csv $CSV_TS_AGNOSTIC_TEST --seed $run --collapse_entities 

# TS evaluation only tokens
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_DEV --goldstandard $GOLDSTANDARD_TS_DEV --csv $CSV_TS_AGNOSTIC_TOK_DEV --seed $run --only_tokens --collapse_entities 
python /home/ealvarezmellado/lrec2024/token-separator-eval/ts_scorer.py --predicted $PREDICTED_TS_TEST --goldstandard $GOLDSTANDARD_TS_TEST --csv $CSV_TS_AGNOSTIC_TOK_TEST --seed $run --only_tokens --collapse_entities   