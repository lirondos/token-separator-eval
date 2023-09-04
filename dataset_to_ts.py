from datasets import load_dataset

id2label = {
    0: "O",
    1: "B-corporation",
    2: "I-corporation",
    3: "B-creative-work",
    4: "I-creative-work",
    5: "B-group",
    6: "I-group",
    7: "B-location",
    8: "I-location",
    9: "B-person",
    10: "I-person",
    11: "B-product",
    12: "I-product",
}
label2id = {
    "O": 0,
    "B-corporation": 1,
    "I-corporation": 2,
    "B-creative-work": 3,
    "I-creative-work": 4,
    "B-group": 5,
    "I-group": 6,
    "B-location": 7,
    "I-location": 8,
    "B-person": 9,
    "I-person": 10,
    "B-product": 11,
    "I-product": 12,
}

def to_ts_notation(item):
    tokens_new = []
    ner_tags_new = []
    for token, tag in zip(reversed(item["tokens"]), reversed(item["ner_tags"])):
        if tag==0:
            ner_tags_new.insert(0, id2label[tag])
            tokens_new.insert(0, token)
            ner_tags_new.insert(0, id2label[tag])
        elif tag%2==0:
            ner_tags_new.insert(0, id2label[tag-1])
            tokens_new.insert(0, token)
            ner_tags_new.insert(0, id2label[tag-1])
        else:
            ner_tags_new.insert(0, id2label[tag])
            tokens_new.insert(0, token)
            ner_tags_new.insert(0, id2label[0])
         
        tokens_new.insert(0, " ")
    tokens_new.pop(0) # we added an extra space at the beginning, we remove it now
    ner_tags_new.pop(0)
    item["tokens"] = tokens_new
    item["ner_tags"] = ner_tags_new
    print(item)
    return item
    
dataset = load_dataset("wnut_17")
    
updated_dataset_train = dataset["train"].map(to_ts_notation)
updated_dataset_val = dataset["validation"].map(to_ts_notation)
updated_dataset_test = dataset["test"].map(to_ts_notation)


sentence1 = [(tok, tag) for tok, tag in zip(updated_dataset_train[0]["tokens"], updated_dataset_train[0]["ner_tags"])]
#sentence2 = [(tok, tag) for tok, tag in zip(updated_dataset_train[0]["tokens_ts"], updated_dataset_train[0]["ner_tags_ts"])]

print(sentence1)

updated_dataset_train.to_json("wnut_17_ts/train.json")
updated_dataset_val.to_json("wnut_17_ts/val.json")
updated_dataset_test.to_json("wnut_17_ts/test.json")





