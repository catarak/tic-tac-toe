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
  #this should be a property of the board, for sure. 
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

    #fork move
    move = find_fork_move(board)
    return move if !move.nil?
    #block opponent fork move

    #center
    move = find_center_move(board)
    return move if !move.nil?

    #opposite corner
    move = find_opposite_corner(board)
    return move if !move.nil?

    #empty corner
    move = find_empty_corner(board)
    return move if !move.nil?

    #empty side
    move = find_empty_side(board)
    return move if !move.nil?

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

  #I KNOW I KNOW I KNOW THIS IS SUPER MESSY DEAL W IT FOR NOW
  def find_fork_move(board)
    #iterate over all groups of two overlapping rows
    #ugh how do you do that
    #okay maybe it's better to find a row that contains your mark but is empty and find overlapping rows
    #yes that is better
    ROWS.each do |row|
      values = [board.get(row[0]), board.get(row[1]), board.get(row[2])]
      #check if row is empty except for your mark, because that's your chance for a fork 
      if values.select{ |value| value == self.mark}.length == 1 && 
          values.select{ |value| value == self.opponent_mark}.length == 0
        #cool so now you might have a fork
        #get row overlaps
        overlaps = ROWS.select{ |overlap| (overlap & row).length > 0 && overlap != row }
        #binding.pry
        overlaps.each do |overlap|
          overlap_values = [board.get(overlap[0]), board.get(overlap[1]), board.get(overlap[2])]
          if overlap_values.select{ |value| value == self.mark}.length == 1 && 
            overlap_values.select{ |value| value == self.opponent_mark}.length == 0
            if overlap[overlap_values.index(self.mark)] != row[values.index(self.mark)]
              binding.pry
              return (overlap & row).first
            end
          #if overlap contains one of mark
          #place a mark in overlapping position
          #how to find overlapping position? return it with overlapping row?
          end
        end
      end
    end
    nil
  end

  def find_center_move(board)
    if board.valid?(board.center_index)
      return board.center_index
    end
  end

  def find_opposite_corner(board)
    board.corner_indices.each do |index|
      if board.get(index) == self.opponent_mark
        opposite_corner_index = board.opposite_corner_index(index)
        return opposite_corner_index if board.valid?(opposite_corner_index)
      end
    end
    nil
  end

  def find_empty_corner(board)
    #TODO make this random :D
    board.corner_indices.each do |index|
      return index if board.valid?(index)
    end
  end

  def find_empty_side(board)
    #TODO make this random :D
    board.side_indices.each do |index|
      return index if board.valid?(index)
    end
  end


end
