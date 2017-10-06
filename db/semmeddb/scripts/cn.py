"""
Link prediction algorithms.
"""

from __future__ import division

import math

import networkx as nx
from networkx.utils.decorators import *

@not_implemented_for('directed')
@not_implemented_for('multigraph')
def cnbors(G, ebunch=None):
  if ebunch is None:
    ebunch = nx.non_edges(G)

  def predict(u, v):
    cnbors = list(nx.common_neighbors(G, u, v))
    return len(cnbors)

  return ((u, v, predict(u, v)) for u, v in ebunch)
