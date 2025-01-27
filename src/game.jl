#  This file contains various methods associated with a full game of tic-tac-toe.

include("board.jl")

# Structure to encode a single game of tic-tac-toe
mutable struct Game 
    winner::Int8
    Nmoves::Int8
    moveList::Array{Int8,1}
    posList
end


# Function to convert a game into an array (for easier search)
function GameStr(game::Game)
    str = zeros(Int8, SIZE^2 + 2)
    str[1] = game.winner
    str[2] = game.Nmoves
    str[3:(SIZE^2 + 2)] = game.moveList
    return str
end


# FUNCTIONS TO PLAY A GAME OF TIC-TAC-TOE
# =========================================================

# Generate a random game starting with the firstPlayer.
# Returns a game encoded as a Game variable. 
# The variable 'board' retains the final board position at the end. 
function RandomGame!(board)
    ResetBoard!(board)
    moveList = zeros(Int8, SIZE^2)
    posList = zeros(Int8, SIZE^2, SIZE^2)

    player = 1
    winner = 0
    Nmoves = SIZE^2   # Default number of moves, unless the game ends early 
    
    for ctr in 1:SIZE^2
        freeList = FreeSqrs(board);  
        move = freeList[ rand( 1:length(freeList) ) ]
        Move!(board, move, player)    
        moveList[ctr] = move
        posList[ctr, :] = copy(FormatInput(board))
            
        winner = CheckWin(board)
        if winner != 0
            Nmoves = ctr
            break
        end

        if player == 1
            player = 2 
        else 
            player = 1
        end 
    end
                    
    return Game(winner, Nmoves, moveList, posList)
end 
                 

# Play a game using the algorithms encoded in functions player1func() and player2func()
# Both these functions are expected to take a board position as input and return a valid move. 
function PlayGame!(board, player1func, player2func)
    ResetBoard!(board)    
    moveList = zeros(Int8, SIZE^2)
    posList = zeros(Int8, SIZE^2, SIZE^2)

    player = 1
    pfunc = player1func 
    winner = 0
    Nmoves = SIZE^2   # Default number of moves, unless the game ends early 
    
    for ctr in 1:SIZE^2
        move = pfunc(board)        
        Move!(board, move, player)

        moveList[ctr] = move
        posList[ctr, :] = copy(FormatInput(board))
        winner = CheckWin(board)
        
        if winner != 0
            Nmoves = ctr
            break
        end

        if player == 1
            player = 2 
            pfunc = player1func 
        else 
            player = 1
            pfunc = player2func 
        end 
        
    end
    
   return Game(winner, Nmoves, moveList, posList) 
end

# DISPLAY FUNCTIONS 
# =========================================================

# Function to display a given board position encoded as a string 
function DisplayBoard(board)
    strList = BoardToStr(board)
    for i in 1:length(strList)
        println(strList[i])
    end 
    println()
    flush(stdout)
end     


# Function to display a game as a sequence of board positions as matrices
function DisplayGameRaw(game::Game)
    for i in 1:game.Nmoves
        display( FormatOutput(game.posList[i,:]) )
    end
end


# Function to display the game as a sequence of board position using ASCII art
function DisplayGame(game::Game)
    if length(game.posList) == 0
        return nothing
    end 
    Npos = game.Nmoves
    strList = Array{String, 1}(undef, SIZE)
    tmpstrList = Array{String, 2}(undef, SIZE, 2*Npos)
    for n in 1:Npos
        tmpstr = BoardToStr( FormatOutput(game.posList[n,:]) )
        for i in 1:SIZE 
            tmpstrList[i,2*n-1] = tmpstr[i]
            tmpstrList[i,2*n] = "    "
        end
    end
    
    for i in 1:SIZE 
        println( join(tmpstrList[i,1:(2*Npos-1)]) )
    end    
    
    println()
    if game.winner == 0
        println("The game was a draw! ")
    else 
        println("The game won by player #$(game.winner) in $(game.Nmoves) moves!")
    end
    flush(stdout)
end


# Function to convert a given board position into an array of strings 
# which are later printed using the DisplayGame function.
function BoardToStr(board)
    tmpboard = board' 
    strList = Array{String, 1}(undef, SIZE)
    strPieces = Array{String, 1}(undef, SIZE)
    for i in 1:SIZE 
        for j in 1:SIZE
           strPieces[j] = join( [ PnumToChar(tmpboard[i,j]), " "])
        end
        strList[i] = join(strPieces)
    end 
    return strList 
end     


# Function to replace the player number (1 or 2) with the cross or nought symbol 
function PnumToChar(n)
    if n == 0
        return '.'
    elseif n == 1
        return 'x'
    elseif n == 2 
        return 'o'
    else 
        return '?'
    end         
end




   