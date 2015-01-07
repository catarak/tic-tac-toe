require 'pry'

class Board
  attr_accessor :board
  attr_reader :rows

  def initialize
    @board = position_numbers
    @rows = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],
             [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
  end

  def position_numbers
    return *(1..9).collect { |x| x.to_s }
  end

  #this isn't super pretty, I tried to find a way to do it with
  #a block but it was even messier
  def to_s
    "      |     |     \n" + 
    "   #{self.board[0]}  |  #{self.board[1]}  |  #{self.board[2]}  \n" +
    " _ _ _|_ _ _|_ _ _\n" +
    "      |     |     \n" + 
    "   #{self.board[3]}  |  #{self.board[4]}  |  #{self.board[5]}  \n" +
    " _ _ _|_ _ _|_ _ _\n" +
    "      |     |     \n" +
    "   #{self.board[6]}  |  #{self.board[7]}  |  #{self.board[8]}  \n" +
    "      |     |     \n" 
  end

  def set(index, mark)
  	self.board[index] = mark
  end

  def get(index)
  	return self.board[index]
  end

  def valid?(index)
    return false if index < 0
    !self.board[index].nil? && self.board[index] != 'X' && self.board[index] != 'O'  
  end

  def open_positions
    self.board.select{ |index| self.valid?(index.to_i - 1) }.map{ |value| board.index(value)}
  end

  def clear_position(index)
    self.set(index, (index + 1).to_s)
  end

  def center_index
    return 4
  end

  def corner_indices
    return [0, 2, 6, 8]
  end

  def side_indices
    return [1, 3, 5, 7]
  end

  def opposite_corner_index(index)
    OPPOSITE_CORNERS[index]
  end

  def values(row)
    [self.get(row[0]), self.get(row[1]), self.get(row[2])]
  end

  def only_two_in_a_row?(row, mark)
    num_mark_in_row(row, mark) == 2 && num_open_positions(row) == 1
  end

  def only_one_in_a_row?(row, mark)
    num_mark_in_row(row, mark) == 1 && num_open_positions(row) == 2
  end

  def three_in_a_row_for_mark?(row, mark)
    num_mark_in_row(row, mark) == 3
  end

  def get_open_position(row)
    row.select{ |index| self.valid?(index) }.first
  end

  def num_open_positions(row)
    row.select{ |index| self.valid?(index) }.length
  end

  def num_mark_in_row(row, mark)
    values = self.values(row)
    values.select{ |value| value == mark }.length
  end

  def overlapping_rows(row)
    self.rows.select{ |overlap| (overlap & row).length > 0 && overlap != row }
  end

  def three_in_a_row?(row)
    self.values(row).uniq.length == 1
  end

  def has_winner?
    self.rows.each do |row|
      return true if three_in_a_row?(row)
    end
    false
  end

  def opposite_mark(mark)
    mark == "X" ? "O" : "X"
  end

  private
    OPPOSITE_CORNERS = {
      0 => 8, 
      2 => 6,
      6 => 2, 
      8 => 0
    }
end
