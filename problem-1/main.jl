function input(prompt::AbstractString="")
    print(prompt)
    return parse(Int64, chomp(readline()))
end

function raw_input(prompt::AbstractString="")
    print(prompt)
    return chomp(readline())
end

function input_special(prompt::AbstractString="")
    print(prompt)
    s = split(chomp(readline()), ",")
    return parse.(Int64, s)
end

# Remove domain from the neigbours/edges
function domain_wipeout(domain, node)
    for i in 1:size(node.edges)[1]
        deleteat!(node.edges[i].domain, findall(x->x==domain,node.edges[i].domain))
    end
end
# Removes all matches of value from list
function clean_node_domain(the_list, val)
    deleteat!(the_list, findall(x->x==val,the_list))
end

mutable struct Variable
    name::AbstractString
    domain::Array{Any,1}
    constraints::Array{Any,1}
    edges::Array{Any,1}
end

variables = []
num_iterations = input("Enter number of variables: ")
# comma separated
ds = input_special("Enter domain for network: ")
for i in 1:num_iterations
    n = raw_input("Give state $i a name:")
    cs = input_special("Enter constraints for $n: ")
    push!(variables, Variable(n, ds, cs, []))
end



# Pretty display
for i in 1:size(variables)[1]
    println("index $i is ",variables[i].name)
end
# Get edges
for i in 1:size(variables)[1]
    # comma separated
    n = variables[i].name
    indices = input_special("Enter index of edges to $n: ")
    for j in 1:size(indices)[1]
        # Set the edges
        push!(variables[i].edges, variables[j])
    end
    println(variables)
end


function constraint_check(domain, compare_domain, constraints)
    # Compare the domain to comapre_domain using the constraints, return true if all pass
    for i in 1:size(constraints)[1]
        if constraints[i] == "!="
            if !(domain != compare_domain)
                return false
            end
        elseif constraints[i] == "=="
            if !(domain == compare_domain)
                return false
            end
        elseif constraints[i] == "<="
            if !(domain <= compare_domain)
                return false
            end
        elseif constraints[i] == ">="
            if !(domain >= compare_domain)
                return false
            end
        end
    end
    return true
end

search_tree = variables

for node_index in 1:size(search_tree)[1]
    node = search_tree[node_index]
    # Select the domain (defaults to index 1 as initial)
    c = node.domain[1]
    # Eliminate domain from edges
    domain_wipeout(c, node)
    
    # Remove other domains from current node for this branch
    # e.g. if current node main domain is RED, reduce domain to [RED]
    for _c_index in 1:size(node.domain)[1]-1
        _c = node.domain[_c_index]
        
        if constraint_check(_c, c, node.constraints) == true
            clean_node_domain(node.domain, _c)
        end
    end
    println(node.name, " -> ", node.domain[1])
end
