import re
import requests

with open("./downloads/drug", "r") as file:
  for line in file:
    line = line.rstrip()
    if re.match(r'^ENTRY', line):
      kegg_id = re.search("D\d+", line).group()
      url = "http://rest.kegg.jp/ddi/" + kegg_id
      request = requests.get(url)
      if request.status_code == 200:
        tsvRsltsL = request.text.split("\n")
        for r in tsvRsltsL:
          if r == '':
            break
          print(r)
