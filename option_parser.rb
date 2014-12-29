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