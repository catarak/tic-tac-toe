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
      name = gets.strip
      @player1 = HumanPlayer.new(name)
      @player2 = ComputerPlayer.new
    elsif options[:mode] == :multiplayer
      puts "Please enter first player's name:"
      name1 = gets.strip
      @player1 = HumanPlayer.new(name1)
      puts "Please enter second player's name:"
      name2 = gets.strip
      @player2 = HumanPlayer.new(name2)
    end
  end

  def initialize_player_order
    puts "Who goes first, #{self.player1.name} or #{self.player2.name}?"
    name = gets.strip
    if name == self.player1.name
      set_as_first(self.player1)
      set_as_second(self.player2)
    else
      set_as_first(self.player2)
      set_as_second(self.player1)
    end
  end

  def set_as_first(player)
    player.mark = 'X'
    self.first = player
  end

  def set_as_second(player)
    player.mark = 'O'
    self.second = player
  end

  def score_to_s
    "Current scores are...\n" + 
    "#{self.player1.name}: #{self.player1.score}\n" +
    "#{self.player2.name}: #{self.player2.score}\n" +
    "Ties: #{self.ties}\n\n"
  end

  def print_score
    print score_to_s
  end

  def run!
    still_playing = true
    while still_playing
      round = Round.new(self.first, self.second)
      round.run!
      adjust_scores(round.winner)
      announce_winner(round.winner)
      reset_player_order(round.winner)
      print_score
      still_playing = play_again?
    end
  end

  def adjust_scores(winner)
    winner.nil? ? self.ties += 1 : winner.score += 1
  end

  def announce_winner(winner)
    announcement = winner.nil? ? "It's a draw.\n" : "#{winner.name} has won!\n"
    puts announcement
  end

  def play_again?
    puts "Play again? (y/n)"
    response = gets.strip
    response != "n"
  end

  def reset_player_order(winner)
    if !winner.nil?
      self.second = winner
      self.first = self.second == self.player1 ? self.player2 : self.player1
    end
  end
end
