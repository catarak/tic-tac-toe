class Fixnum
  N_BYTES = [42].pack('i').size
  N_BITS = N_BYTES * 8
  MAX = 2 ** (N_BITS - 2) - 1
  MIN = -MAX - 1
end

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
    value = minimax(board, 2, self.mark, Fixnum::MIN, Fixnum::MAX)[:position]
  end

  def minimax(board, depth, mark, alpha, beta)
    best_position = -1
    if depth == 0 || board.open_positions.empty?
      score = evaluate_score(board)
      return {score: score, position: best_position}
    else
      board.open_positions.each do |index|
        board.set(index, mark)
        if mark == self.mark
          score = minimax(board, depth - 1, self.opponent_mark, alpha, beta)[:score]
          if score > alpha
            alpha = score
            best_position = index
          end
        else
          score = minimax(board, depth - 1, self.mark, alpha, beta)[:score]
          if score < beta
            beta = score
            best_position = index
          end
        end
        board.clear_position(index)
        if alpha >= beta
          break
        end
      end
    end
    best_score = self.mark == mark ? alpha : beta
    {score: best_score, position: best_position}
  end

  def evaluate_score(board)
    board.rows.inject(0) do |score, row| 
      score + evaluate_score_for_row(board, row)
    end
  end

  def evaluate_score_for_row(board, row)
    if board.three_in_a_row_for_mark?(row, self.mark)
      100
    elsif board.three_in_a_row_for_mark?(row, self.opponent_mark)
      -100
    elsif board.only_two_in_a_row?(row, self.mark)
      10
    elsif board.only_two_in_a_row?(row, self.opponent_mark)
      -10
    elsif board.only_one_in_a_row?(row, self.mark)
      1
    elsif board.only_one_in_a_row?(row, self.opponent_mark)
      -1
    else
      0
    end
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
      test_board = Marshal.load(Marshal.dump(board))
      test_board.set(move, self.mark)
      opponent_move = find_winning_move(test_board)
      if opponent_move 
        test_board.set(opponent_move, self.opponent_mark)
        if !contains_fork?(test_board, self.opponent_mark)
          return move
        end
      else
        #test_board.set(opponent_move, (opponent_move + 1).to_s)
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
    return nil if board.corner_indices.none?{ |index| board.valid?(index) }
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
    return nil if board.side_indices.none?{ |index| board.valid?(index) }
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
