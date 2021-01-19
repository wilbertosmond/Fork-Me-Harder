# Pre-able: Import libraries
import json
import csv

# Convert DBpedia files into single list
people_data = []
# alpha = ['A', 'B', 'C', "D", 'E', 'F', 'G', 'H', 'I', 'J', 'K', "L", 'M', 'N', 'O', 'P', 'Q', 'R', "S", 'T', 'U', 'V', \
#          'W', 'X', 'Y', 'Z']
# for letter in alpha:
#     with open(f'.\People\{letter}_people.json') as file:
#         data_inter = json.load(file)
#         people_data.extend(data_inter)
with open(f'.\People\A_people.json') as file:
    data_inter = json.load(file)
    people_data.extend(data_inter)

# Convert wiki_genders.txt file to dictionary
with open('wiki_genders.txt', encoding="utf8") as file:
    headers = file.readline()
    people_gender = {}
    for line in file:
        wiki_id, gender, name = line.strip().split('\t')
        name = name.replace(' ','_')
        people_gender[name] = gender

# Preprocessing: Cleaned Dataset removes fictional characters includes entries for which birthYear or birthDate has been reported.
people_cleaned = []
for entry in people_data:
    if ('fictional character' not in entry['http://www.w3.org/1999/02/22-rdf-syntax-ns#type_label']) and \
            (('ontology/birthYear' in entry.keys()) or ('ontology/birthDate' in entry.keys())):
        people_cleaned.append(entry)

# Convert people_cleaned lists to dicts
people_cleaned = {person['title']: person for person in people_cleaned}

# Check if names in wiki_genders.txt file match with those in A_People.json, and then get only those dictionaries
names = people_cleaned.keys()
names_gender = people_gender.keys()
people_merge = {}
for name in names:
    if name in names_gender:
        people_cleaned[name].update({'gender': people_gender[name]})
        people_merge[name] = people_cleaned[name]

# convert cleaned data to csv
    # for entry in people_merge:
    #     #print(name['first name'])
    #     if 'ontology/education_label' in entry:
    #         file.write(f"{entry['title']},{entry['ontology/education_label']}\n")
    #     else:
    #         file.write(f"{entry['title']},'N/A'\n")
people_list = list(people_merge.values())
with open('gender_df.csv', 'w', encoding='utf8') as file:
    file.write('Name,Gender,Alma_Mater,Education,Occupation,Profession,Net_Worth,Known_For,Relation,Relative,Spouse,Children,Parent\n')
    for data in people_list:
        file.write(f"{data.get('title')},{data.get('gender')},{data.get('ontology/almaMater_label')},{data.get('ontology/education_label')},{data.get('ontology/occupation_label')},{data.get('ontology/profession_label')},{data.get('ontology/networth')},{data.get('ontology/knownFor_label')},{data.get('ontology/knownFor_label')},{data.get('ontology/relation_label')},{data.get('ontology/relative_label')},{data.get('ontology/spouse_label')},{data.get('ontology/child_label')},{data.get('ontology/parent_label')}\n")
