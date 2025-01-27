#  This file contains various methods associated with the tic-tac-toe board setup and game play.

const SIZE = 3

board =  zeros(Int8, SIZE,SIZE); 

FormatInput(board) = reshape( board, (SIZE^2,1) )
FormatOutput(output) = reshape( output, (SIZE,SIZE) )

# Function to create a new board
# The board is stored as a SIZE x SIZE matrix, where each element is 0, 1 or 2.
# corresponding to an empty square, cross and nought respectively.
function CreateBoard()
    return zeros(Int8, SIZE,SIZE)
end 

# Function to reset the board to an empty state
function ResetBoard!(board)
    board .*= 0 
end 


# Check if there are empty squares left on the board. 
function CheckEmpty(board)
    prod = 1
    for i in 1:SIZE
        for j in 1:SIZE
            prod *= board[i,j]
        end 
    end 
    return 1 - sign(prod)
end 


#  List the free squares on a given board. 
function FreeSqrs(board)
    free = []
    for i in 1:SIZE
        for j in 1:SIZE
            if board[i,j] == 0
                append!(free, SIZE*(j-1) + i)
            end
        end 
    end 
    return free
end 

# Given a board state, check if there is a winner. 
# Returns 1,2 if player1, player2 is the winner, and 0 if there is no winner. 
function CheckWin(board)
    for i in 1:SIZE
        # Check row i 
        if board[i,1] != 0  
            flag = true      
            for j in 2:SIZE
                if board[i,j] != board[i,1]
                    flag = false
                end 
            end
            if flag 
                # print("Win @ row ", i)
                return board[i,1]
            end
        end
                
        # Check column i 
        if board[1,i] != 0  
            flag = true      
            for j in 2:SIZE
                if board[j,i] != board[1,i]
                    flag = false
                end 
            end
            if flag 
                # print("Win @ column ", i)
                return board[1,i]
            end
        end
    end
    
    
    # Check main diagonal 
    if board[1,1] != 0  
        flag = true      
        for j in 2:SIZE
            if board[j,j] != board[1,1]
                flag = false
            end 
        end
        if flag 
            # print("Win @ main diagonal ")
            return board[1,1]
        end
    end
    
    # Check alternate diagonal 
    if board[1,SIZE] != 0  
        flag = true      
        for j in 2:SIZE
            if board[j,SIZE+1-j] != board[1,SIZE]
                flag = false
            end 
        end
        if flag 
            # print("Win @ alternate diagonal ")
            return board[1,SIZE]
        end
    end
    
    return 0 
    
end 

# Implement a given move on the board. 
# Returns 1 if the move is successful and 0 if the square was already occupied. 
function Move!(board, move, player)
    if length(move) == 1
        rem = mod(move, 1:SIZE)
        pos = [rem, convert(Int8,(move-rem)/SIZE + 1)]
    else 
        pos = move
    end
    
    if board[pos[1], pos[2]] == 0
        board[pos[1], pos[2]] = player 
        return 1 
    else 
        return 0
    end
end


# Function to play a sequence of moves on a given board.
function SeqMoves!(board, moveseq, printFlag=false)        
    ResetBoard!(board)
    player = 1
    for i in 1:length(moveseq)
        if moveseq[i] == 0
            break
        end
        
        Move!(board, moveseq[i], player)    
        if printFlag 
            display(board)
        end 
        
        if player == 1
            player = 2 
        else 
            player = 1
        end 
    end
end
                                    
