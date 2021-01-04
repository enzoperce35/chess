require './interface.rb'

describe ConsoleInterface do
  describe '#prompt_name' do
    it 'sends a prompt question to output' do
      output = StringIO.new

      console_interface = ConsoleInterface.new(output: output)

      console_interface.prompt_name(1)

      expect(output.string).to include("Playing")
    end
  end

  describe '#answer' do
    it 'returns a formatted string received from input' do
      input = StringIO.new("input\n")

      console_interface = ConsoleInterface.new(input: input)

      expect(console_interface.answer).to eq("input")
    end
  end
end