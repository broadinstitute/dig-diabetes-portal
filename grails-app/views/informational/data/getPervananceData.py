import re
import json
import os

'''
output should look like this
{id1: {"URL":<>,"data":<>}, id2: {"URL":<>,"data":<>}}
'''

data = []
inner_data = {}
id_name = ""
for filename in os.listdir('/Users/psingh/broadProjects/dig-diabetes-portal/grails-app/views/informational/data'):
    if (filename.endswith(".gsp")):
        with open(filename, "r") as f:
            lines = f.readlines()
            dict_data = {}


            for line in lines:
                if("id=" in line):
                    id_name = line.split("id=")[1].split("_script")[0].strip(' "\t\n')
                if("Download date" in line):
                    dict_data["Download date"] = line.split("Download date:")[1].replace('<br', " ").replace('/>\n', "").strip(' "\t\n')
                    inner_data[id_name] = dict_data
                if("Download URL:" in line):
                    if(id_name == "ExSeq_EgnomAD"):
                        dict_data["URI"] = "https://storage.googleapis.com/gnomad-public/release/2.0.2/vcf/exomes/gnomad.exomes.r2.0.2.sites.vcf.bgz"
                    elif(id_name == "WGS_WgnomAD"):
                        dict_data["URI"] = "https://storage.googleapis.com/gnomad-public/release/2.0.2/vcf/genomes/gnomad.genomes.r2.0.2.sites.chrXX.vcf.bgz"
                    else:
                        dict_data["URI"] = line.split("href=")[1].split("</a>")[0].replace("target", "").replace('\\', ' ').split(" =\"_blank")[0].strip(' >"\t\n').split('">')[0]
                    #print(line.split("href=")[1].split("</a>")[0].replace("target", "").replace('\\', ' ').split(" =\"_blank")[0].strip(' >"\t\n').split('">')[0])
                    inner_data[id_name] = dict_data
                if("Data set version:" in line):
                    dict_data['Version'] = line.split("Data set version:")[1].split("<br/></p>")[0].strip(' "\t\n')
                    inner_data[id_name] = dict_data
                if("Genotype Data Quality Control Report" in line):
                    dict_data['Genotype Data Quality Control Report'] = line.split("href=")[1].split("target")[0].split("download")[0].strip(' >"\t\n')
                    inner_data[id_name] = dict_data

            data.append(inner_data)
        continue
    else:
        continue

#json_data = json.dumps(data)
json_data = json.dumps(inner_data, indent=4, sort_keys=True)

#print(json_data)
with open('pervananceData.txt', 'w') as f:
    f.write(json_data)
