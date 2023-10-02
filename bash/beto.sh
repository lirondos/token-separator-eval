#!/bin/bash
source /home/ealvarezmellado/miniconda3/etc/profile.d/conda.sh

CUDA_VISIBLE_DEVICES=1
export OUT_DIR=/home/ealvarezmellado/borrowings-acl-2022/out/beto

export DATA_DIR_TEST=/home/ealvarezmellado/transformers/examples/legacy/token-classification/data_test
export LABELS=/home/ealvarezmellado/transformers/examples/legacy/token-classification/labels.txt
export MAX_LENGTH=260
export BATCH_SIZE=16
export NUM_EPOCHS=3
export SAVE_STEPS=750



(
for run in {1..10}; do
    export OUTPUT_RUN_DIR="$OUT_DIR"/run"$run"
    export OUTPUT_DIR_TEST="$OUTPUT_RUN_DIR"/test_results/oct2023

    export SEED=$run
    #export SEED=$((RANDOM % 10))
    rm /home/ealvarezmellado/transformers/examples/legacy/token-classification/cached_*

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
        

done
)


