import json

people_data = []
alpha = ['A', 'B', 'C', "D", 'E', 'F', 'G', 'H', 'I', 'J', 'K', "L", 'M', 'N', 'O', 'P', 'Q', 'R', "S", 'T', 'U', 'V', \
         'W', 'X', 'Y', 'Z']
for letter in alpha:
    with open(f'.\People\{letter}_people.json') as file:
        data_inter = json.load(file)
        people_data.extend(data_inter)

count = 0
total = len(data)
gender_list = []
for i in range(len(data)):
    if "ontology/gender_label" in data[i].keys():
        gender_list.append(data[i]['ontology/gender_label'])
        count += 1
