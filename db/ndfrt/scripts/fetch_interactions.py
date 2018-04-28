from SPARQLWrapper import SPARQLWrapper, JSON

sparql = SPARQLWrapper('http://sparql.bioontology.org/sparql/')
api_key = '5dd5cf8a-bdc9-4d46-9c3d-10aadff89444'

sparql.addCustomParameter('apikey', api_key)

q = '''
PREFIX umls: <http://bioportal.bioontology.org/ontologies/umls/> 
PREFIX skos: <http://www.w3.org/2004/02/skos/core#> 
PREFIX ndfrt: <http://purl.bioontology.org/ontology/NDFRT/> 
SELECT *
WHERE {
  ?s ndfrt:NDFRT_KIND ?o;
  skos:prefLabel ?label;
  umls:cui ?cui;
  ndfrt:SEVERITY ?severity. FILTER (regex(str(?o), "interaction", "i"))
  ?s ndfrt:has_participant ?targetDrug.
 }
'''

sparql.setQuery(q)  
sparql.setReturnFormat(JSON)
resultset = sparql.query().convert()

cache = [None, None]
for i in range(0, len(resultset['results']['bindings'])):
  uri = resultset['results']['bindings'][i]['s']['value']
  if uri == cache[0]:
    drug1 = cache[1].rpartition('/')[2]
    drug2 = resultset['results']['bindings'][i]['targetDrug']['value'].rpartition('/')[2]
    print(drug1, drug2, sep='\t')
    cache = [None, None]
  else:
    cache[0] = uri
    cache[1] = resultset['results']['bindings'][i]['targetDrug']['value']
    continue
