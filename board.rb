class Board
  attr_accessor :board
  attr_reader :rows

  def initialize
    @board = position_numbers
    @rows = [[0,1,2], [3,4,5], [6,7,8], [0,3,6],
             [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
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

  def position_numbers
    return *(1..9).collect { |x| x.to_s }
  end

  def valid?(index)
    self.board[index] != 'X' && self.board[index] != 'O'  
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

  #is there a better way to do this
  def has_winner?
    self.board[0] == self.board[1] && self.board[1] == self.board[2] ||
    self.board[3] == self.board[4] && self.board[4] == self.board[5] ||
    self.board[6] == self.board[7] && self.board[7] == self.board[8] ||
    self.board[0] == self.board[3] && self.board[3] == self.board[6] ||
    self.board[1] == self.board[4] && self.board[4] == self.board[7] ||
    self.board[2] == self.board[5] && self.board[5] == self.board[8] ||
    self.board[0] == self.board[4] && self.board[4] == self.board[8] ||
    self.board[2] == self.board[4] && self.board[4] == self.board[6]
  end

  private
    OPPOSITE_CORNERS = {
      0 => 8, 
      2 => 6,
      6 => 2, 
      8 => 0
    }
end
