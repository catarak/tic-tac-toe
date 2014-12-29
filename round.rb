#!/usr/bin/env ruby

# Cassie Tarakajian
# 08/20/2014
# ctarakajian@gmail.com

require_relative 'player'
require_relative 'board'

class Round
	attr_accessor :winner

  def initialize(first_player, second_player)
    @board = Board.new
    @first_player = first_player
    @second_player = second_player
    @num_moves = 0
    @current_player = first_player
    @winner = nil
  end
  
  def run!
    while true
    	if @current_player.class.name != "ComputerPlayer"
    	  @board.print_board
      end

    	move = get_move(@current_player)
      place_move(move, @current_player)

      if over?
      	@board.print_board
        break
      end
      change_current_player
    end
    
    #set winner
    @winner = @current_player
  end

  def place_move(move, player)
    @board.set(move, player.mark)
    @num_moves += 1
  end

  def get_move(player)
    move = 0
    while !@board.is_valid(move = player.get_input) 
    end
    return move
  end

  def change_current_player
    if @current_player == @first_player
      @current_player = @second_player
    else
    	@current_player = @first_player
    end
  end

  def over?
    if @num_moves < 5
    	return false
    #if it is a DRAW, set winner to nil
    elsif @num_moves == 9 
    	@current_player = nil
    	return true
    else 
    	return @board.has_winner?
    end
  end

end