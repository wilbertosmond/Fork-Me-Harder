# convert wiki_genders.txt file to dictionary
with open('wiki_genders.txt', encoding="utf8") as file:
    headers = file.readline()
    people = []
    for line in file:
        wiki_id, gender, name = line.strip().split('\t')
        name = name.replace(' ','_')
        people.append({'wiki id': wiki_id,
                      'gender': gender,
                      'name': name})

# check if names in wiki_genders.txt file match with those in A_People.json, and then get only those dictionaries
import json
with open('People/A_People.json') as file:
    A_People = json.load(file)
    df = []
    for line1 in people:    
        for line2 in A_People:
            if line1['name'] == line2['title']:
                df.append(line2)
                break