require_relative 'player'
require_relative 'board'

class Round
	attr_accessor :winner, :current_player, :first_player, :second_player, :board, :num_moves

  def initialize(first_player, second_player)
    @board = Board.new
    @first_player = first_player
    @second_player = second_player
    @num_moves = 0
    @current_player = first_player
    @winner = nil
  end
  
  def run!
    while true
    	if self.current_player.class.name != "ComputerPlayer"
    	  print board
      end

    	move = get_move(@current_player)
      place_move(move, @current_player)

      if over?
      	print board
        break
      end
      change_current_player
    end
    
    #set winner
    self.winner = self.current_player
  end

  def place_move(move, player)
    self.board.set(move, player.mark)
    increment_num_moves
  end

  def increment_num_moves
    self.num_moves += 1
  end

  def get_move(player)
    move = 0
    while !self.board.is_valid?(move = player.move) 
    end
    move
  end

  def change_current_player
    if self.current_player == self.first_player
      self.current_player = self.second_player
    else
    	self.current_player = self.first_player
    end
  end

  def over?
    if self.num_moves < 5
    	return false
    #if it is a DRAW, set winner to nil
    elsif self.num_moves == 9 
    	self.current_player = nil
    	return true
    else 
    	return self.board.has_winner?
    end
  end

end