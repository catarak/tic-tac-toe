#!/usr/bin/env ruby

# Cassie Tarakajian
# 08/20/2014
# ctarakajian@gmail.com

require 'optparse'
require_relative 'player'
require_relative 'board'
require_relative 'round'

class TicTacToe
  def initialize(options)
    @options = options
    @board = Board.new
    @ties = 0

    #initialize mode
    if options[:mode] == :single
      puts "Please enter your name:"
      name = gets.chomp
      @player1 = HumanPlayer.new(name)
      @player2 = ComputerPlayer.new
    elsif options[:mode] == :multiplayer
      puts "Please enter first player's name:"
      name1 = gets.chomp
      @player1 = HumanPlayer.new(name1)
      puts "Please enter second player's name:"
      name2 = gets.chomp
      @player2 = HumanPlayer.new(name2)
    end

    #initialize player order
    @first = @player1
    @second = @player2
    set_turn_order
  end

  def set_turn_order
    puts "Who goes first, #{@player1.name} or #{@player2.name}?"
    name = gets.chomp
    if name == @player1.name
      @player1.mark = 'X'
      @player2.mark = 'O'
      @first = @player1
      @second = @player2
    else
      @player1.mark = 'O'
      @player2.mark = 'X'
      @first = @player2
      @second = @player1
    end
  end

  def print_score
    puts "Current scores are..."
    puts "#{@player1.name}: #{@player1.score}"
    puts "#{@player2.name}: #{@player2.score}"
    puts "Ties: #{@ties}"
    puts ""
  end

  def run!
    while true
      round = Round.new(@first, @second)
      round.run!
      adjust_scores(round.winner)
      announce_winner(round.winner)
      reset_player_order(round.winner)
      print_score
      if !play_again?
        break
      end
    end
  end

  def adjust_scores(winner)
    if (winner != nil)
      winner.score +=1
    else
      @ties += 1
    end
  end

  def announce_winner(winner)
    if (winner != nil)
      puts "#{winner.name} has won!"
    else
      puts "It's a draw."
    end
    puts ""
  end

  def play_again?
    puts "Play again? (y/n)"
    response = gets.chomp
    if response == "n"
      return false
    else
      return true
    end
  end

  def reset_player_order(winner)
    if (winner != nil)
      @second = winner
      @first = @second == @player1 ? @player2 : @player1
    end
  end
end

class TicTacToeOptionParser
  attr_reader :options
  def initialize
    @options = {}
    @parser = OptionParser.new do |opts|
      opts.banner = "Usage: tic_tac_toe.rb [options]"

      opts.on("-m", "--mode [MODE]", [:single, :multiplayer], "Select player mode (single, multiplayer)") do |m|
        options[:mode] = m
      end

      opts.on('-h', '--help', 'Display this screen') do
        puts opts
        exit
      end
    end
  end

  def parse!
    begin
      @parser.parse!
      mandatory = [:mode]                                         
      missing = mandatory.select{ |param| options[param].nil? }        
      if not missing.empty?                                            
        puts "Missing options: #{missing.join(', ')}"                  
        puts @parser                                                 
        exit                                                           
      end
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument 
      puts $!.to_s                                                           
      puts @parser                                                          
      exit
    end
  end
end

#### MAIN ####
parser = TicTacToeOptionParser.new
parser.parse!
game = TicTacToe.new(parser.options)
game.run!
