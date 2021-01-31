__author__      = "Bob Lutz"
__copyright__   = "Copyright 2020, Bob Lutz"

def symmetric_difference(A: "a list",
                         B: "another list"):
    C = sorted(A + B)
    D = list(set(C))
    for i in D:
        a = A.count(i)
        b = B.count(i)
        for j in range(a + b - abs(a - b)):
            C.remove(i)
    return C

def reduced_power(G: "base graph",
                  k: "number of factors"):
    V = G.vertices()
    E = G.edges(labels = false)
    U = list(UnorderedTuples(V, k))
    product_edges = []
    for i in range(len(U) - 1):
        for j in range(i + 1, len(U)):
            C = tuple(symmetric_difference(U[i], U[j]))
            if len(C) == 2 and C in E:
                product_edges.append([i, j])
    return Graph(product_edges)

def token_graph(G: "base graph",
                k: "number of factors"):
    V = G.vertices()
    if k > len(V):
        print("Number of factors exceeds order of base graph")
        return
    E = G.edges(labels = false)
    Usets = list(Subsets(V, k))
    U = [list(u) for u in Usets]
    product_edges = []
    for i in range(len(U) - 1):
        for j in range(i + 1, len(U)):
            C = tuple(symmetric_difference(U[i], U[j]))
            if len(C) == 2 and C in E:
                product_edges.append([i, j])
    return Graph(product_edges)

def is_induced_four_cycle(G: "a graph",
                          c: "a 4-cycle of the graph"):
    if len(c) != 5:
        return False
    E = G.edges(labels=false)
    return not tuple(sorted(c[0:3:2])) in E and not tuple(sorted(c[1:4:2])) in E

# Constructs the 2-complex obtained from a graph by attaching a 2-cell to each
# 3- and 4-cycle
def xg(G: "a graph"):
    cycles = DiGraph(G).all_simple_cycles(max_length = 4)
    three_cycles = [c[:-1] for c in cycles if len(c) == 4]
    induced_four_cycles = [c for c in cycles if is_induced_four_cycle(G, c)]
    triangulated_four_cycles = [c[0:3] for c in induced_four_cycles]
    edge_list = [list(e) for e in G.edges(labels = false)]
    faces = three_cycles + triangulated_four_cycles + edge_list
    return SimplicialComplex(faces)

def discrete_fundamental_group(G: "a graph"):
    return xg(G).fundamental_group()

# Constructs a graph that is an n-fold wedge sum of m-cycles
def polygon_wedge(m: "order of each wedge summand",
                  n: "number of wedge summands"):
    if m < 3:
        print("Number of polygon sides must be at least 3.")
        return
    if n < 1:
        print("Number of wedge factors must be positive.")
        return
    edges = [
        [0 if i == 0 else i + (m-1)*j, (i + (m-1)*j + 1) % (m + (m-1)*j)]
            for i in range(m) for j in range(n)
        ]
    return Graph(edges)

# 1-skeleta of quadrilaterizations of common surfaces
rpp_quad = Graph([[0, 1], [0, 6], [1, 2], [1, 10], [1, 25], [2, 3], [2, 11],
    [2, 24], [3, 4], [3, 12], [3, 23], [4, 5], [4, 13], [4, 22], [5, 9],
    [6, 7], [6, 10], [6, 25], [7, 8], [7, 14], [7, 21], [8, 9], [8, 17],
    [8, 18], [9, 13], [9, 22], [10, 11], [10, 14], [11, 12], [11, 15],
    [12, 13], [12, 16], [13, 17], [14, 15], [14, 18], [15, 16], [15, 19],
    [16, 17], [16, 20], [17, 21], [18, 19], [18, 22], [19, 20], [19, 23],
    [20, 21], [20, 24], [21, 25], [22, 23], [23, 24], [24, 25]])
kb_quad = Graph([[1, 2], [1, 5], [1, 6], [1, 21], [2, 3], [2, 7], [2, 25],
    [3, 4], [3, 8], [3, 24], [4, 5], [4, 9], [4, 23], [5, 10], [5, 22], 
    [6, 7], [6, 11], [6, 10], [7, 8], [7, 12], [8, 9], [8, 13], [9, 10], 
    [9, 14], [10, 15], [11, 12], [11, 15], [11, 16], [12, 13], [12, 17], 
    [13, 14], [13, 18], [14, 15], [14, 19], [15, 20], [16, 17], [16, 20],
    [16, 21], [17, 18], [17, 22], [18, 19], [18, 23], [19, 20], [19, 24],
    [20, 25], [21, 22], [21, 25], [22, 23], [23, 24], [24, 25]])
torus_quad = Graph([[1, 2], [1, 5], [1, 6], [1, 21], [2, 3], [2, 7], [2, 22],
    [3, 4], [3, 8], [3, 23], [4, 5], [4, 9], [4, 24], [5, 10], [5, 25],
    [6, 7], [6, 11], [6, 10], [7, 8], [7, 12], [8, 9], [8, 13], [9, 10],
    [9, 14], [10, 15], [11, 12], [11, 16], [11, 15], [12, 13], [12, 17],
    [13, 14], [13, 18], [14, 15], [14, 19], [15, 20], [16, 21], [16, 17],
    [16, 20], [17, 18], [17, 22], [18, 19], [18, 23], [19, 20], [19, 24],
    [20, 25], [21, 22], [21, 25], [22, 23], [23, 24], [24, 25]])