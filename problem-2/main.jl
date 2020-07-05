function input(prompt::AbstractString="")
    print(prompt)
    return parse(Int64, chomp(readline()))
end

function input_special(prompt::AbstractString="")
    print(prompt)
    s = split(chomp(readline()), ",")
    return parse.(Int64, s)
end
# Capture strategies for first player
p1_strats = []
for i in 1:input("How many strategies for player 1:")
    push!(p1_strats, input_special("Enter strategy $i: "))
end
println()
# Capture strategies for second player
p2_strats = []
for i in 1:input("How many strategies for player 2:")
    push!(p2_strats, input_special("Enter strategy $i: "))
end

# p1_strats = [[5, 4], [3, 3], [2, 4], [4, 5]]
# p2_strats = [[2, 1, 1, 3], [2, 2, 1, 4]]

# Returns bool
function is_a_strictly_dominant(a, b)
    for i in 1:size(a)[1]
        if a[i] < b[i] || a[i] in b
            return false
        end
    end
    return true
end

# Returns bool
function is_a_weakly_dominant(a, b)
    counts = 0
    for i in 1:size(a)[1]
        if a[i] > b[i]
            counts += 1
        end
    end
    if counts == size(a)[1]
        # Totally dominates
        return false
    end
    if counts > 0
        # Weakly dominates
        return true
    end
end

function make_unique(arr)
    used = []
    for i in 1:size(arr)[1]
        if !(arr[i] in used)
            push!(used, arr[i])
        end
    end
    return used
end

# Returns bool
function is_a_fully_dominated(a, b)
    counts = 0
    for i in 1:size(a)[1]
        if b[i] > a[i]
            counts += 1
        end
    end
    if counts == size(a)[1]
        # Totally dominated
        return true
    end
    return false
end

# 1. Find the strictly dominant strategy
# Returns: int, index
function strictly_dominate_strategy(strategies)
    strong_index = -1
    for i in 1:size(strategies)[1]
        println("Iteration No. $i")
        row = strategies[i]
        # Compare with other strategies but exclude self first
        temp_strategies = deepcopy(strategies)
        deleteat!(temp_strategies, i)
        for j in 1:size(temp_strategies)[1]
            temp_row = temp_strategies[j]
            # Check if we are still dominant
            if is_a_strictly_dominant(row, temp_row) == true
                if strong_index == -1
                    strong_index = i
                    println(row, " is strictly dominant over ", temp_row)
                elseif is_a_strictly_dominant(row, strategies[strong_index]) == true
                    strong_index = i
                    println("[reset] ",row, " is strictly dominant over ", strategies[strong_index])
                else
                    println("[reset]", row, " is not strictly dominant over ", strategies[strong_index])
                    strong_index = -1
                end
            end
        end
    end
    return strong_index
end

# 2. Find the weakly dominant strategy
# Returns: int, the index
function weakly_dominate_strategy(strategies)
    weak_index = []
    for i in 1:size(strategies)[1]
        println("Iteration No. $i")
        row = strategies[i]
        # Compare with other strategies excluding self
        temp_strategies = deepcopy(strategies)
        deleteat!(temp_strategies, i)
        for j in 1:size(temp_strategies)[1]
            temp_row = temp_strategies[j]
            # Check if we are weakly dominant
            if is_a_weakly_dominant(row, temp_row) == true
                push!(weak_index, i)
                println(strategies[i], " is weakly dominant over ", temp_row)
            end
        end
    end
    return weak_index
end

# 3. Find the dominated strategies
# Returns: array of dominated strategies
function get_dominated_strategies(strategies)
    dominated_strategies = []
    for i in 1:size(strategies)[1]
        println("Iteration No. $i")
        row = strategies[i]
        # Compare with other strategies excluding self
        temp_strategies = deepcopy(strategies)
        deleteat!(temp_strategies, i)
        for j in 1:size(temp_strategies)[1]
            temp_row = temp_strategies[j]
            # Check if row is dominated
            if is_a_fully_dominated(row, temp_row) == true
                println(row, " is dominated by ", temp_row)
                push!(dominated_strategies,strategies[i])
                break
            end
        end
    end
    return dominated_strategies
end

println("Player 1 findings:")
println()
println("-----------------Strictly dominant Strategy------------")
# Strictly dominant
strictly_index = strictly_dominate_strategy(p1_strats)
# Watch out for BoundsError incase no result is found
if strictly_index == -1
    output_strictly = "None found"
else
    output_strictly = p1_strats[strictly_index]
end
println("∴ final result => ", output_strictly)
println()
println("-----------------Weakly dominant Strategy------------")
# Weakly dominant
weakly_index = make_unique(weakly_dominate_strategy(p1_strats))
if weakly_index == []
    output_weakly = "None found"
else
    output_weakly = []
    for i in 1:size(weakly_index)[1]
        push!(output_weakly, p1_strats[weakly_index[i]])
    end
#     output_weakly = p1_strats[weakly_index]
end
println("∴ final result => ", output_weakly)
println()
println("-----------------Dominated Strategies------------")
# Dominated
dominated_strats = get_dominated_strategies(p1_strats)
if dominated_strats == []
    output_dominated = "None found"
else
    output_dominated = dominated_strats
end
println("∴ final result => ", output_dominated)

println("Player 2 findings:")
println()
println("-----------------Strictly dominant Strategy------------")
# Strictly dominant
strictly_index = strictly_dominate_strategy(p2_strats)
# Watch out for BoundsError incase no result is found
if strictly_index == -1
    output_strictly = "None found"
else
    output_strictly = p2_strats[strictly_index]
end
println("∴ final result => ", output_strictly)
println()
println("-----------------Weakly dominant Strategy------------")
# Weakly dominant
weakly_index = make_unique(weakly_dominate_strategy(p2_strats))
if weakly_index == []
    output_weakly = "None found"
else
    output_weakly = []
    for i in 1:size(weakly_index)[1]
        push!(output_weakly, p2_strats[weakly_index[i]])
    end
end
println("∴ final result => ", output_weakly)
println()
println("-----------------Dominated Strategies------------")
# Dominated
dominated_strats = get_dominated_strategies(p2_strats)
if dominated_strats == []
    output_dominated = "None found"
else
    output_dominated = dominated_strats
end
println("∴ final result => ", output_dominated)
