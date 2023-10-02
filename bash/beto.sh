#!/bin/bash
source ~/miniconda3/etc/profile.d/conda.sh

CUDA_VISIBLE_DEVICES=1
export OUT_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/beto
export CSV_FILE_DEV="$OUT_DIR"/dev_results.csv
export CSV_FILE_TEST="$OUT_DIR"/test_results.csv

#mkdir $OUT_DIR
#echo SEED,TYPE,PRECISION,RECALL,F1 > $CSV_FILE_DEV
#echo SEED,TYPE,PRECISION,RECALL,F1 > $CSV_FILE_TEST

export DATA_DIR_TEST=/home/ealvarezmellado/transformers/examples/legacy/token-classification/data_test
export DATA_DIR_DEV=/home/ealvarezmellado/transformers/examples/legacy/token-classification
export LABELS=/home/ealvarezmellado/transformers/examples/legacy/token-classification/labels.txt
export MAX_LENGTH=260
export BATCH_SIZE=16
export NUM_EPOCHS=3
export SAVE_STEPS=750
export BERT_MODEL=dccuchile/bert-base-spanish-wwm-cased
export DEV=/home/ealvarezmellado/transformers/examples/legacy/token-classification/dev.txt
export TEST="$DATA_DIR_TEST"/test.txt



(
for run in {6..10}; do
    export OUTPUT_RUN_DIR="$OUT_DIR"/run"$run"
    export OUTPUT_FILE_TEST="$OUTPUT_RUN_DIR"/test_predictions.txt
    export OUTPUT_DIR_TEST="$OUTPUT_RUN_DIR"/test_results

    export SEED=$run
    #export SEED=$((RANDOM % 10))
    rm /home/ealvarezmellado/transformers/examples/legacy/token-classification/cached_*
    
    conda activate huggingface

    python /home/ealvarezmellado/transformers/examples/legacy/token-classification/run_ner.py \
    --data_dir $DATA_DIR_DEV \
    --labels $LABELS \
    --model_name_or_path $BERT_MODEL \
    --output_dir $OUTPUT_RUN_DIR \
    --max_seq_length  $MAX_LENGTH \
    --num_train_epochs $NUM_EPOCHS \
    --per_device_train_batch_size $BATCH_SIZE \
    --save_steps $SAVE_STEPS \
    --seed $SEED \
    --do_train \
    --do_eval \
    --do_predict 
    
    mv "$OUTPUT_RUN_DIR"/test_predictions.txt "$OUTPUT_RUN_DIR"/dev_predictions.txt
    mv "$OUTPUT_RUN_DIR"/test_results.txt "$OUTPUT_RUN_DIR"/dev_results.txt
    
    export OUTPUT_FILE_DEV="$OUTPUT_RUN_DIR"/dev_predictions.txt

    
    conda activate seqscore 
    
    python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $DEV --predicted $OUTPUT_FILE_DEV --seed $SEED --csv $CSV_FILE_DEV

    conda activate huggingface
    
    rm "$DATA_DIR_TEST"/cached_*


    python /home/ealvarezmellado/transformers/examples/legacy/token-classification/run_ner.py \
    --data_dir $DATA_DIR_TEST \
    --labels $LABELS \
    --model_name_or_path $OUTPUT_RUN_DIR \
    --output_dir $OUTPUT_DIR_TEST \
    --max_seq_length  $MAX_LENGTH \
    --num_train_epochs $NUM_EPOCHS \
    --per_device_train_batch_size $BATCH_SIZE \
    --save_steps $SAVE_STEPS \
    --seed $SEED \
    --do_predict 
    
    export OUTPUT_FILE_TEST="$OUTPUT_DIR_TEST"/test_predictions.txt

    conda activate seqscore 
    
    python /home/ealvarezmellado/borrowings-acl-2022/scripts/evaluate.py --reference $TEST --predicted $OUTPUT_FILE_TEST --seed $SEED --csv $CSV_FILE_TEST

done
)


