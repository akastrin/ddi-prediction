import sys
import pandas as pd
import networkx as nx
import community
import itertools

sys.path.insert(0, './scripts')
import cn

def all_pairs(iterable):                                                     
  return itertools.combinations(iterable, 2)

G = nx.read_edgelist("./data/drugbank_interactions.tsv", delimiter="\t", nodetype=str)

partition = community.best_partition(G)
nx.set_node_attributes(G, name='community', values=partition)

ap = list(all_pairs(G.nodes()))

cn = cn.cnbors(G, ap)
rai = nx.resource_allocation_index(G, ap) 
jc = nx.jaccard_coefficient(G, ap)  
aai = nx.adamic_adar_index(G, ap)
pa = nx.preferential_attachment(G, ap)
ccn = nx.cn_soundarajan_hopcroft(G, ap)
cra = nx.ra_index_soundarajan_hopcroft(G, ap)
wic = nx.within_inter_cluster(G, ap, community='community') 

u, v, s1, s2, s3, s4, s5, s6, s7, s8, has_edge = ([] for i in range(11))
for m1, m2, m3, m4, m5, m6, m7, m8 in zip(cn, rai, jc, aai, pa, ccn, cra, wic):                                              
  u.append(m1[0])                                 
  v.append(m1[1])                                                            
  s1.append(m1[2])                                                         
  s2.append(m2[2])                
  s3.append(m3[2])
  s4.append(m4[2])
  s5.append(m5[2])
  s6.append(m6[2])
  s7.append(m7[2])
  s8.append(m8[2])  
  has_edge.append(int(G.has_edge(m1[0], m2[1])))    

df = pd.DataFrame({'u': u, 'v': v, 'cn': s1, 'rai': s2, 'jc': s3, 'aai': s4, 'pa': s5, 'ccn': s6, 'cra': s7, 'wic': s8, 'has_edge': has_edge})
df = df[['u', 'v', 'cn', 'rai', 'jc', 'aai', 'pa', 'ccn', 'cra', 'wic', 'has_edge']]
df.to_csv("./data/topology_measures.txt", index=False, index_label=False)


