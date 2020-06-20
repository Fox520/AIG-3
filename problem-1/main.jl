@enum Colors RED GREEN BLUE
mutable struct Variable
    name::AbstractString
    domain::Array{Any,1}
    edges::Array{Any,1}
end

# Remove color from the neigbours/edges
function domain_wipeout(color, node)
    for i in 1:size(node.edges)[1]
        deleteat!(node.edges[i].domain, findall(x->x==color,node.edges[i].domain))
    end
end
# Removes all matches of value from list
function clean_node_domain(the_list, val)
    deleteat!(the_list, findall(x->x==val,the_list))
end

WA = Variable("Western Australia", [RED, GREEN, BLUE], [])
NT = Variable("Northern Territories", [RED, GREEN, BLUE], [])
SA = Variable("South Australia", [RED, GREEN, BLUE], [])
Q = Variable("Queensland", [RED, GREEN, BLUE], [])
NSW = Variable("New South Wales", [RED, GREEN, BLUE], [])
V = Variable("Victoria", [RED, GREEN, BLUE], [])
T = Variable("Tasmania", [RED, GREEN, BLUE], [])

# Set the neighbours/edges
WA.edges = [NT, SA]
NT.edges = [WA, SA, Q]
SA.edges = [WA, NT, Q, NSW, V]
Q.edges = [NT, SA, NSW]
NSW.edges = [Q, SA, V]
V.edges = [SA, NSW, T]
T.edges = [V]
# Using SA as starting point
search_tree = [SA, WA, NT, Q, NSW, V, T]

for node_index in 1:size(search_tree)[1]
    node = search_tree[node_index]
    # Select the color (defaults to RED as initial)
    c = node.domain[1]
    # Eliminate color from edges
    domain_wipeout(c, node)
    
    # Remove other colors from current node for this branch
    # So if current node color is RED, reduce domain to [RED]
    for _c_index in 1:size(node.domain)[1]-1
        _c = node.domain[_c_index]
        
        if _c != c
            clean_node_domain(node.domain, _c)
        end
    end
    println(node.name, " -> ", node.domain[1])
end
