module Playable
  attr_accessor :player_type, :score, :name, :mark

  def initialize(name)
    @score = 0
    @name = name
    @mark = nil
  end
end

class HumanPlayer
	include Playable
  def move
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
class ComputerPlayer
	include Playable

  def initialize
    super("Computer")
    #initialze probabilities board
    @probabilities_board = Board.new
  end

	def move
    Random.rand(9)
  end
end
