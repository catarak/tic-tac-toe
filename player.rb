class Player
  attr_accessor :player_type, :score, :name, :mark

  def initialize(name)
    @score = 0
    @name = name
    @mark = nil
  end
end

class HumanPlayer < Player
  def move(board)
    #this does not sanitize or check for errors in input
    puts "#{self.name}, please choose a position, or type 'quit' to quit: "
    input = gets.strip
    if input == "quit"
      exit
    else 
    	input.to_i - 1 #need to normalize position
    	                      #this also returns an invalid move if 
    	                      #user inputs a random string
    end
  end
end

#The AI for this is pretty dumb right now
#TODO actually make this AI work
class ComputerPlayer < Player
  PROBABILITIES = [3, 2, 3, 2, 4, 2, 3, 2, 3]

  def initialize
    super("Computer")
    #initialze probabilities board
    @prob_board = Board.new(PROBABILITIES)
  end

	def move(board)
    #recalculate probabilities
    #choose spot based on probability
    #check other player wins
    #check for self wins
    #if neither, pick highest probability spot
    Random.rand(9)
  end
end
