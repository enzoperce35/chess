class ConsoleInterface
  attr_accessor :input, :output

  def initialize(output: $stdout, input: $stdin)
    @input = input
    @output = output
  end

  def prompt_name(player)
    color = player == 1 ? 'white' : 'black'

    @output.puts "Who's Playing #{color}?"

    #answer
  end

  def answer
    @input.gets.chomp!
  end
end