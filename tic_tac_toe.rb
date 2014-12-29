require 'optparse'
require_relative 'player'
require_relative 'board'
require_relative 'round'

class TicTacToe
  attr_accessor :player1, :player2, :options, :board, :ties, :first, :second
  def initialize(options)
    @options = options
    @board = Board.new
    @ties = 0

    initialize_mode(options)
    initialize_player_order
  end

  def initialize_mode(options)
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
  end

  def initialize_player_order
    @first = @player1
    @second = @player2
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

  def score_to_s
    "Current scores are...\n" + 
    "#{@player1.name}: #{@player1.score}\n" +
    "#{@player2.name}: #{@player2.score}\n" +
    "Ties: #{@ties}\n\n"
  end

  def print_score
    print score_to_s
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
