struct Vertex
    id::Int
end
mutable struct Edge
    id::Int
    u::Vertex
    v::Vertex
    weight::Float64
    state::Symbol # :neutral, :short, :cut
end
struct GameGraph
    vertices::Vector{Vertex}
    edges::Vector{Edge}
    s::Vertex
    t::Vertex
end
mutable struct GameState
    graph::GameGraph
    current_player::Symbol
    history::Vector{Tuple{Symbol, Edge}}
    winner::Union{Symbol, Nothing}
end

function new_game(g::GameGraph)::GameState
    for i in g.edges 
        i.state = :neutral
    end 
    return GameState(graph = g ,current_player = :short ,
    history=Vector{Tuple{Symbol, Edge}}(),
    winner = nothing  )
end 

function valid_moves(state::GameState)::Vector{Edge}
    v = []
    for i in state.graph.edges 
        if i.state=== :neutral
            push!(v,i)
        end 
    end 
    return v 
end 
function check_winner(state::GameState)::Union{Symbol, Nothing}
    #Gewinn Bedingung Short 
    s = state.graph.s 
    Q =[s]
    
    visited =[]
    while !isempty(Q)
        l =popfirst!(Q)
        if l === state.graph.t 
            
            return  :short 
            
        end 
        for i in state.graph.edges 
            if i.u == l && i.state=== :short && i.v !in visited  
                push!(Q,i.v)
                push!(visited,i.v)
            elseif i.v == l && i.state=== :short && i.u !in visited  
                push!(Q,i.u)
                push!(visited,i.u)
            end 
        end 
    end
    #Gewinn Bedingung Cut
    s = state.graph.s 
    Q =[s]
    
    visited =[]
    a = false 
    while !isempty(Q)
        l =popfirst!(Q)
        if l === state.graph.t 
            a = true 
             
            break
        end 
        for i in state.graph.edges 
            if i.u == l && i.state !== :cut && i.v !in visited  
                push!(Q,i.v)
                push!(visited,i.v)
            elseif i.v == l && i.state !== :cut && i.u !in visited  
                push!(Q,i.u)
                push!(visited,i.u)
            end 
        end 
    end
    if a ==false 
        return :cut 
    end 
    return nothing
     
end 
function make_move!(state::GameState, e::Edge)::Nothing
    if state.current_player === :short 
        e.state= :short 
        push!(state.history,(:short , e))
        state.current_player = :cut
        

        
     
    elseif state.current_player === :cut 
            e.state= :cut 
            push!(state.history,(:cut , e))
            state.current_player = :short 
            
    end 
    state.winner = check_winner(state)
    return nothing 
end
using Random
function  random_graph(n::Int, m::Int; weighted=false)::GameGraph
    v = []
    e = []
    for i in range(1,n)
        push!(v,Vertex(i))
    end 
    for k in range(1,m)
        push!(e,Edge(k,v[k],v[k+1],0,:neutral))
    end 
    
    return GameGraph(v , e , v[1],v[n])
    




end 








