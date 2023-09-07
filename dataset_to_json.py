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

def from_int_to_bio(item):
    ner_tags_new = []
    for tag in item["ner_tags"]:
        ner_tags_new.append(id2label[tag])
    item["ner"] = ner_tags_new
    del item["ner_tags"]
    #del item["tokens"]
    print(ner_tags_new)
    print(item)
    return item
    
dataset_train = load_dataset("wnut_17", split="train")
dataset_val = load_dataset("wnut_17", split="validation")
dataset_test = load_dataset("wnut_17", split="test")


    
dataset_train = dataset_train.map(from_int_to_bio, load_from_cache_file=False)
dataset_val = dataset_val.map(from_int_to_bio, load_from_cache_file=False)
dataset_test = dataset_test.map(from_int_to_bio, load_from_cache_file=False)

    
dataset_train.to_json("wnut_17_bio/train.json")
dataset_val.to_json("wnut_17_bio/val.json")
dataset_test.to_json("wnut_17_bio/test.json")
