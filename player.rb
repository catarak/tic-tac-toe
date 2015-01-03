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
    puts "#{self.name}, please choose a position, or enter 'quit' or 'q' to quit: "
    input = gets.strip
    if input == "quit" || input == "q"
      exit
    else 
    	input.to_i - 1 #need to normalize position
    end
  end
end

class ComputerPlayer < Player

  def initialize
    super("Computer")
  end

	def move(board)
    move = find_winning_move(board) || 
           find_blocking_move(board) ||
           find_winning_fork_move(board) ||
           find_blocking_fork_move(board) ||
           find_center_move(board) ||
           find_opposite_corner(board) ||
           find_empty_corner(board) ||
           find_empty_side(board)
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

  def contains_fork?(board, mark)
    two_in_a_row = []
    board.rows.each do |row|
      if board.only_two_in_a_row?(row, mark)
        two_in_a_row << row
      end
    end
    return two_in_a_row.length > 1
  end

  def select_blocking_fork_move(board, possible_forks)
    possible_moves = possible_forks.flatten.uniq.select{ |index| board.valid?(index) }
    possible_moves.each do |move|
      #binding.pry
      test_board = Marshal.load(Marshal.dump(board))
      test_board.set(move, self.mark)
      opponent_move = find_winning_move(test_board)
      if opponent_move
        test_board.set(opponent_move, self.opponent_mark)
        if !contains_fork?(test_board, self.opponent_mark)
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
    move
  end
end
