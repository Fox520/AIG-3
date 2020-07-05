mutable struct State
    utility::Float64
    reward::Float64
    transitions::Array{Any,1}
end

DISCOUNT = 0.5
max_error = 0.001

s1 = State(0, 3, [])
s2 = State(0, -1, [])
push!(s1.transitions, [s2, 1.0])
push!(s1.transitions, [s1, 0.5])
push!(s1.transitions, [s2, 0.5])

push!(s2.transitions, [s1, 1.0])
push!(s2.transitions, [s2, 1.0])

states = [s1, s2]
function get_max_transitions(transitions)
    results = []
    if size(transitions)[1] > 1
        # Just to be sure that not only one transition/action is present
        for i in 2:size(transitions)[1]
#             println("pushing to result")
            push!(results, transitions[i][2] * transitions[i][1].utility)
        end
    end
#     println(transitions[1][2] * transitions[1][1].utility, " vs ", sum(results))
    return max(transitions[1][2] * transitions[1][1].utility, sum(results))
end

function value_iteration(state, previous_utility)
    if abs(state.utility - previous_utility)  == 0#< max_error * (1 - DISCOUNT) / DISCOUNT
        println("Converge ", state.utility," ", previous_utility)
        return state
    end
    previous_utility = state.utility
    # U(s) <- reward + beta * max(P*utilityOftransState)
    state.utility = state.reward + DISCOUNT * get_max_transitions(state.transitions)
    println("Current utility => ",state.utility, " Previous => ",previous_utility)
    return value_iteration(state, previous_utility)
end

iteration_count = 0
while true
    # Julia wants these initialised
    delta = 0
    current_state = undef
    previous_utility = 0
    for i in 1:size(states)[1]
        current_state = states[i]
        previous_utility = current_state.utility
        # U(s) <- reward + beta * max(P*utilityOftransState) <- for all transitions of this state 
        current_state.utility = current_state.reward + DISCOUNT * get_max_transitions(current_state.transitions)
        println("Current utility => ",current_state.utility, " Previous => ",previous_utility)
        delta = abs(current_state.utility - previous_utility)
    end
    iteration_count += 1
    println("Iteration: ", iteration_count)
    if delta < max_error * (1 - DISCOUNT) / DISCOUNT
        println("Converge ", current_state.utility," ", previous_utility)
        break
    end
    # utility + reward + beta * max(P*utilityOftransState)
end
for i in 1:size(states)[1]
    println(states[i].utility)
end
