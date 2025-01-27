# This file contains the definition of a neural network and various methods relevant to its training.

# Structure to encode a neural network 
mutable struct NeuralNetwork
    Nlayers::Int8
    DimList::Array{Int8,1}   # List of dimensions of each layer
    WeightList  # List of weight matrices
    ThresList   # List of activation thresholds
    NLfunc      # Nonlinear activation function 
end

# The sigmoid activation function
sigmoid(x) = 1/(1+exp(-x))

# Outer product of two vectors (yields a matrix)
Tprod(vec1, vec2) = reshape(vec1, (length(vec1),1)) * reshape(vec2, (1, length(vec2))) 

# Initialize a Neural Network with given number of neurons and 
# the weights/thresholds distributed uniformly in [-1,1]. 
function CreateNN(DimList, NLfunc)
    WeightList = []
    ThresList = []
    Nlayers = length(DimList)
    for i in 1:(Nlayers-1)
        push!(WeightList, 2 .* rand(DimList[i+1], DimList[i]) .- 1)
        push!(ThresList, 2 .* rand(DimList[i+1]) .- 1)
    end
    return NeuralNetwork(Nlayers, DimList, WeightList, ThresList, NLfunc)
end

# Makes a copy of a given neural network data. 
function CopyNN(NN)
    return NeuralNetwork(NN.Nlayers, NN.DimList, NN.WeightList, NN.ThresList, NN.NLfunc)
end
    

# Print out various matrices of the neural network. 
function ViewNN(NN::NeuralNetwork)
    println("The neural network has 1 input, 1 output and $(NN.Nlayers-2) hidden layers.\n")
    for i in 1:(NN.Nlayers-1)
        println("Layer #$(i-1) has dimension $(NN.DimList[i])")
        print("Transition matrix from layer $i to layer $(i+1) is: ")
        flush(stdout)
        display(NN.WeightList[i])
        print("Threshold for activation of layer $(i+1) is: ")
        flush(stdout)
        display(NN.ThresList[i])
    end    
    println("Layer #$(NN.Nlayers) has dimension $(NN.DimList[NN.Nlayers])")
end
    
   
# Evaluate the neural network for a given input.
function EvalNN(NN::NeuralNetwork, input)
    res = []
    push!(res, copy(input))
    for i in 1:(NN.Nlayers-1)
        push!(res, NN.NLfunc.( NN.WeightList[i]*res[i] + NN.ThresList[i] ))
    end
    return res 
end
    

# Backpropagation algorithm to train the neural network.
# The current implementation is specific for the sigmoid activation function! 
function BackPropNN!(NN::NeuralNetwork, input, outputExpec, rate)
    # This is space-inefficient. Redo this with in-place updates! 
    newWlist = copy(NN.WeightList)
    newTlist = copy(NN.ThresList)
    
    output = EvalNN(NN, input)
    
    # Derivative computed using f'(x) = f(x) [1 - f(x)] for the sigmoid
    deriv = []
    for i in 1:NN.Nlayers
        push!(deriv, output[i] .* (1 .- output[i]))
    end
    
    diff = output[NN.Nlayers] .- outputExpec
    prefac = rate * diff .* deriv[NN.Nlayers]
    
    i = NN.Nlayers-1
    newWlist[i] -= Tprod(prefac, output[i])
    newTlist[i] -= prefac     
    
    for i in (NN.Nlayers-2):-1:1
        prefac = (NN.WeightList[i+1]' * prefac) .* deriv[i+1]
        newWlist[i] -= Tprod(prefac, output[i])
        newTlist[i] -= prefac     
    end

    NN.WeightList = newWlist
    NN.ThresList = newTlist
    
    return 0
end
    
# Train the neural network using the backpropagation algorithm and 
# a given labelled dataset.
function TrainNN!(NN, Niter, inputList, outputExpecList, rate)
    Ninpts = length(inputList)
    
    for i in 1:Niter 
        j = rand(1:Ninpts)
        BackPropNN!(NN, inputList[j], outputExpecList[j], rate)
    end 
        
end
