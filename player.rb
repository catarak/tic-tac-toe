require_relative 'fixnum'

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
    if board.three_in_a_row?(row, self.mark)
      100
    elsif board.three_in_a_row?(row, self.opponent_mark)
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

end
