require 'pry'

class Player
  attr_accessor :player_type, :score, :name, :mark
  attr_reader :mark, :opponent_mark

  def initialize(name)
    @score = 0
    @name = name
    @mark = nil
  end

  def mark=(mark)
    @mark = mark
    if mark == "X"
      @opponent_mark = "O"
    else
      @opponent_mark = "X"
    end
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
  ROWS = [[0,1,2],
          [3,4,5],
          [6,7,8],
          [0,3,6],
          [1,4,7],
          [2,5,8],
          [0,4,8],
          [2,4,6]]

  def initialize
    super("Computer")
  end

	def move(board)
    move = find_winning_move(board)
    return move if !move.nil?
    move = find_blocking_move(board)
    return move if !move.nil?

    #strategy and all of that shit
    Random.rand(9)
  end

  def find_winning_move(board)
    #there is most definitely a better way to do this
    ROWS.each do |row|
      values = [board.get(row[0]), board.get(row[1]), board.get(row[2])] 
      if values.select{ |value| value == self.mark}.length == 2
        possible_move = values.select{ |value| value != self.mark}.first
        if possible_move != self.opponent_mark
          return row[values.index(possible_move)]
        end
      end
    end
    nil
  end

  def find_blocking_move(board)
    #there is most definitely a better way to do this
    ROWS.each do |row|
      values = [board.get(row[0]), board.get(row[1]), board.get(row[2])] 
      if values.select{ |value| value == self.opponent_mark}.length == 2
        possible_move = values.select{ |value| value != self.opponent_mark}.first
        if possible_move != self.mark
          return row[values.index(possible_move)]
        end
      end
    end
    nil
  end

  #this allows you to create a move
  def find_fork_move(board)
    #iterate over all groups of two overlapping rows
    #ugh how do you do that
    #okay maybe it's better to find a row that contains your mark but is empty and find overlapping rows
    #yes that is better
    ROWS.each do |row|
      values = [board.get(row[0]), board.get(row[1]), board.get(row[2])] 
      if values.select{ |value| value == self.mark}.length == 1 && 
          values.select{ |value| value == self.opponent_mark}.length == 0
        #cool so now you might have a fork
        #get row overlaps
      end
    end
  end


end
