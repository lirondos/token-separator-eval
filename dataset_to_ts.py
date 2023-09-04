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
    item["tokens_ts"] = tokens_new
    item["ner_tags_ts"] = ner_tags_new
    return item
    
dataset = load_dataset("wnut_17", split="train")
    
updated_dataset = dataset.map(to_ts_notation)

sentence1 = [(tok, tag) for tok, tag in zip(updated_dataset[0]["tokens"], updated_dataset[0]["ner_tags"])]
sentence2 = [(tok, tag) for tok, tag in zip(updated_dataset[0]["tokens_ts"], updated_dataset[0]["ner_tags_ts"])]

print(sentence1)
print(sentence2)


