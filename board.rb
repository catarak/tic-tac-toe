#!/usr/bin/env ruby

# Cassie Tarakajian
# 08/20/2014
# ctarakajian@gmail.com

class Board
  def initialize
    @board = *(1..9).collect { |x| x.to_s }
  end

  #this isn't super pretty, I tried to find a way to do it with
  #a block but it was even messier
  def print_board
    print "      |     |     \n"
    print "   #{@board[0]}  |  #{@board[1]}  |  #{@board[2]}  \n"
    print " _ _ _|_ _ _|_ _ _\n"
    print "      |     |     \n"
    print "   #{@board[3]}  |  #{@board[4]}  |  #{@board[5]}  \n"
    print " _ _ _|_ _ _|_ _ _\n"
    print "      |     |     \n"
    print "   #{@board[6]}  |  #{@board[7]}  |  #{@board[8]}  \n"
    print "      |     |     \n"
  end

  def set(index, mark)
  	@board[index] = mark
  end

  def get(index)
  	return @board[index]
  end

  def is_valid(index)
    if @board[index] == 'X' || @board[index] == 'O'
      return false
    else
    	return true
    end   
  end

  #is there a better way to do this
  def has_winner?
    if @board[0] == @board[1] && @board[1] == @board[2] ||
       @board[3] == @board[4] && @board[4] == @board[5] ||
       @board[6] == @board[7] && @board[7] == @board[8] ||
       @board[0] == @board[3] && @board[3] == @board[6] ||
       @board[1] == @board[4] && @board[4] == @board[7] ||
       @board[2] == @board[5] && @board[5] == @board[8] ||
       @board[0] == @board[4] && @board[4] == @board[8] ||
       @board[2] == @board[4] && @board[4] == @board[6]
      return true
    else
    	return false
    end
  end
end
