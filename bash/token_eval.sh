#!/bin/bash
source /home/ealvarezmellado/miniconda3/etc/profile.d/conda.sh
conda activate lrec2024

export run=0
export RESULTS_DIR=/home/ealvarezmellado/lrec2024/token-separator-eval/wnut_17_conll/results/token_eval
mkdir $RESULTS_DIR

export CSV_TOK_DEV="$RESULTS_DIR"/tok_dev.csv
export CSV_TOK_TEST="$RESULTS_DIR"/tok_test.csv
export CSV_TOK_AGNOSTIC_DEV="$RESULTS_DIR"/ts_agnostic_dev.csv
export CSV_TOK_AGNOSTIC_TEST="$RESULTS_DIR"/ts_agnostic_test.csv




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

# TS evaluation
echo "TRAINED W/O BARS: TOKEN"

python /home/ealvarezmellado/lrec2024/token-separator-eval/token_eval.py --predicted $PREDICTED_SPANS_DEV --goldstandard $GOLDSTANDARD_SPANS_DEV --csv $CSV_TOK_DEV --seed $run 
python /home/ealvarezmellado/lrec2024/token-separator-eval/token_eval.py --predicted $PREDICTED_SPANS_TEST --goldstandard $GOLDSTANDARD_SPANS_TEST --csv $CSV_TOK_TEST --seed $run 

# AGNOSTIC

# Span evaluation
echo "TRAINED W/O BARS: TOKEN AGNOSTIC"
python /home/ealvarezmellado/lrec2024/token-separator-eval/token_eval.py --predicted $PREDICTED_SPANS_AGNOSTIC_DEV --goldstandard $GOLDSTANDARD_SPANS_AGNOSTIC_DEV --csv $CSV_TOK_AGNOSTIC_DEV --seed $run --collapse_entities
python /home/ealvarezmellado/lrec2024/token-separator-eval/token_eval.py --predicted $PREDICTED_SPANS_AGNOSTIC_TEST --goldstandard $GOLDSTANDARD_SPANS_AGNOSTIC_TEST --csv $CSV_TOK_AGNOSTIC_TEST --seed $run --collapse_entities

#######################################################################
#######################################################################
#######################################################################
#######################################################################
#######################################################################
#######################################################################

# Evaluation trained with bars

export RESULTS_DIR=/home/ealvarezmellado/lrec2024/token-separator-eval/wnut_17_conll/results/token_eval
export CSV_TOK_DEV="$RESULTS_DIR"/bar_tok_dev.csv
export CSV_TOK_TEST="$RESULTS_DIR"/bar_tok_test.csv
export CSV_TOK_AGNOSTIC_DEV="$RESULTS_DIR"/bar_tok_agnostic_dev.csv
export CSV_TOK_AGNOSTIC_TEST="$RESULTS_DIR"/bar_tok_agnostic_test.csv



# Evaluation trained without bars
export EVALUATION_DIR=/home/ealvarezmellado/lrec2024/deberta-json-bar-out
export PREDICTED_SPANS_DEV="$EVALUATION_DIR"/predictions_conll_dev.txt
export PREDICTED_SPANS_AGNOSTIC_DEV="$EVALUATION_DIR"/predictions_conll_agnostic_dev.txt
export PREDICTED_TS_DEV="$EVALUATION_DIR"/predictions_conll_bar_dev.txt

export PREDICTED_SPANS_TEST="$EVALUATION_DIR"/predictions_conll_test.txt
export PREDICTED_SPANS_AGNOSTIC_TEST="$EVALUATION_DIR"/predictions_conll_agnostic_test.txt
export PREDICTED_TS_TEST="$EVALUATION_DIR"/predictions_conll_bar_test.txt


# TS evaluation
echo "TRAINED BARS: TOK"

python /home/ealvarezmellado/lrec2024/token-separator-eval/token_eval.py --predicted $PREDICTED_SPANS_DEV --goldstandard $GOLDSTANDARD_SPANS_DEV --csv $CSV_TOK_DEV --seed $run 
python /home/ealvarezmellado/lrec2024/token-separator-eval/token_eval.py --predicted $PREDICTED_SPANS_TEST --goldstandard $GOLDSTANDARD_SPANS_TEST --csv $CSV_TOK_TEST --seed $run

# Agnostic
python /home/ealvarezmellado/lrec2024/token-separator-eval/token_eval.py --predicted $PREDICTED_SPANS_AGNOSTIC_DEV --goldstandard $GOLDSTANDARD_SPANS_AGNOSTIC_DEV --csv $CSV_TOK_AGNOSTIC_DEV --seed $run --collapse_entities
python /home/ealvarezmellado/lrec2024/token-separator-eval/token_eval.py --predicted $PREDICTED_SPANS_AGNOSTIC_TEST --goldstandard $GOLDSTANDARD_SPANS_AGNOSTIC_TEST --csv $CSV_TOK_AGNOSTIC_TEST --seed $run --collapse_entities
