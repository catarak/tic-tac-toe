class Board
  attr_accessor :board

  def initialize
    @board = position_numbers
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

  #I don't like this, it's ugly!
  def opposite_corner_index(index)
    return nil if !self.corner_indices.include?(index)
    case index
    when 0
      8
    when 2
      6
    when 6
      2
    when 8
      0
    end
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

end
