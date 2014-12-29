#!/usr/bin/env ruby

# Cassie Tarakajian
# 08/20/2014
# ctarakajian@gmail.com

module Player
  attr_accessor :player_type, :score, :name, :mark

  def initialize(name)
    @score = 0
    @name = name
    @mark = nil
  end
end

class HumanPlayer
	include Player
  def get_input
    #this does not sanitize or check for errors in input
    puts "#{@name}, please choose a position, or type 'quit' to quit: "
    input = gets.chomp
    if input == "quit"
      exit
    else 
    	return input.to_i - 1 #need to normalize position
    	                      #this also returns an invalid move if 
    	                      #user inputs a random string
    end
  end
end

#The AI for this is pretty dumb right now
class ComputerPlayer
	include Player
  def initialize
    super("Computer")
  end
	def get_input
    return Random.rand(9)
  end
end
