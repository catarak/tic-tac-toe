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

  def initialize
    super("Computer")
  end

  #this should also be cleaned up
	def move(board)
    move = find_winning_move(board)
    return move if !move.nil?
    move = find_blocking_move(board)
    return move if !move.nil?

    #strategy and all of that shit

    #fork move
    move = find_winning_fork_move(board)
    return move if !move.nil?
    #block opponent fork move
    move = find_blocking_fork_move(board)
    return move if !move.nil?

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
    return find_two_in_a_row(board, self.mark)
  end

  def find_blocking_move(board)
    return find_two_in_a_row(board, self.opponent_mark)
  end

  def find_two_in_a_row(board, mark)
    board.rows.each do |row|
      if board.only_two_in_a_row?(row, mark)
        return board.get_open_position(row)
      end
    end
    nil
  end

  def find_winning_fork_move(board)
    board.rows.each do |row|
      if board.only_one_in_a_row?(row, self.mark)
        overlaps = board.overlapping_rows(row)
        overlaps.each do |overlap|
          if board.only_one_in_a_row?(overlap, self.mark)
            overlapping_move = (overlap & row).first
            return overlapping_move if board.valid?(overlapping_move)
          end
        end
      end
    end
    nil
  end

  def find_blocking_fork_move(board)
    possible_forks = find_possible_forks(board, self.opponent_mark)
    select_blocking_fork_move(board, possible_forks)
  end

  def find_possible_forks(board, mark)
    possible_forks = []
    board.rows.each do |row|
      if board.only_one_in_a_row?(row, self.opponent_mark)
        overlaps = board.overlapping_rows(row)
        overlaps.each do |overlap|
          if board.only_one_in_a_row?(overlap, self.opponent_mark)
            overlapping_move = (overlap & row).first
            if board.valid?(overlapping_move)
              possible_forks << [row, overlap]
            end
          end
        end
      end
    end
    possible_forks.each{ |fork| fork.sort! }.uniq
  end

  def select_blocking_fork_move(board, possible_forks)
    possible_moves = possible_forks.flatten.uniq.select{ |index| board.valid?(index) }
    #iterate through possible moves
    #if move can create two in a row for self AND other player blocking doesn't create fork, then choose it
    possible_moves.each do |move|
      test_board = Marshal.load(Marshal.dump(board))
      test_board.set(move, self.mark)
      opponent_move = find_winning_move(test_board)
      if opponent_move
        test_board.set(opponent_move, self.opponent_mark)
        if find_possible_forks(test_board, self.opponent_mark).length == 0
          return move
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
    found_move = false
    while !found_move
      move = board.corner_indices.sample
      if board.valid?(move)
        found_move = true
      end
    end
    move
  end

  def find_empty_side(board)
    found_move = false
    while !found_move
      move = board.side_indices.sample
      if board.valid?(move)
        found_move = true
      end
    end
    binding.pry
    move
  end


end
