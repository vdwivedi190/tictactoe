include("game.jl")

# Convert the move (given as the square number) to a vector.
function ConvertMove(m::Int8)
    vec = zeros(Int8, SIZE^2) 
    vec[m] = 1
    return vec
end

# Update the buffer of games with the result of playing a single game 
# that is not a draw. Here, pfunc is the function encoding a particular strategy. 
function UpdateBuffer!(board, pfunc, posBuf, movBuf, ind)
    win = 0 
    local game::Game

    # Loop until a game is not a draw
    ctr=0
    while win < 1
        game = PlayGame!(board, pfunc, pfunc)
        win = game.winner
        ctr += 1 
    end
    
#     if win == 1
#         start = 3
#     else
#         start = 2 
#     end

    # Only store positions from the 3rd move onwards
    start = 3

    # Add the game to the training data buffer 
    for i in start:2:game.Nmoves
        posBuf[ind] = game.posList[i-1,:]
        movBuf[ind] = ConvertMove(game.moveList[i])
        ind += 1
    end
    flush(stdout)

    return ind 
end

# Function to train the neural network to play Tic-Tac-Toe.
function TrainTicTacToe(Npos, Nrounds, Ntraining, trainingRate)
    # Initialize the neural network
    playerNN = CreateNN([SIZE^2,SIZE^2,SIZE^2,SIZE^2],sigmoid);

    # Initialize the position and move buffers to hold the training data
    posBuf = Array{ Array{Int8, 1 }, 1}(undef, Npos)
    movBuf = Array{ Array{Int8, 1 }, 1}(undef, Npos)
    pList = Array{ NeuralNetwork,1 }(undef, Nrounds)

    rg = 1:(Npos-SIZE-2)      

    println("Starting training...")

    for ctr in 1:Nrounds
        print("Training round $ctr...")
        
        # Update the buffers
        ind = 1
        while ind < Npos-SIZE  
            println("Updating the buffer at round $ctr.")
            ind = UpdateBuffer!(board, NNPlay, posBuf, movBuf, ind)
        end
        
        Train using the games in the buffer 
        TrainNN!(playerNN, Ntraining, posBuf[rg], movBuf[rg], trainingRate)
        pList[ctr] = CopyNN(playerNN)
        
        println("Done.")
        flush(stdout)
    end    
    
end