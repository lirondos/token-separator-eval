from datasets import load_dataset

def to_ts_notation(item):
    tokens_new = []
    ner_tags_new = []
    for token, tag in zip(reversed(item["tokens"]), reversed(item["ner_tags"])):
        if tag==0:
            ner_tags_new.insert(0, tag)
            tokens_new.insert(0, token)
            ner_tags_new.insert(0, tag)
        elif tag%2==0:
            ner_tags_new.insert(0, tag-1)
            tokens_new.insert(0, token)
            ner_tags_new.insert(0, tag-1)
        else:
            ner_tags_new.insert(0, tag)
            tokens_new.insert(0, token)
            ner_tags_new.insert(0, 0)
         
        tokens_new.insert(0, " ")
    tokens_new.pop(0) # we added an extra space at the beginning, we remove it now
    ner_tags_new.pop(0)
    item["tokens"] = tokens_new
    item["ner_tags"] = ner_tags_new
    return item
    
dataset = load_dataset("wnut_17")
    
updated_dataset_train = dataset["train"].map(to_ts_notation)
updated_dataset_val = dataset["validation"].map(to_ts_notation)
updated_dataset_test = dataset["test"].map(to_ts_notation)


#sentence1 = [(tok, tag) for tok, tag in zip(updated_dataset_train[0]["tokens"], updated_dataset_train[0]["ner_tags"])]
#sentence2 = [(tok, tag) for tok, tag in zip(updated_dataset_train[0]["tokens_ts"], updated_dataset_train[0]["ner_tags_ts"])]


updated_dataset_train.to_csv("wnut_17_ts/train.csv")
updated_dataset_val.to_csv("wnut_17_ts/val.csv")
updated_dataset_test.to_csv("wnut_17_ts/test.csv")





