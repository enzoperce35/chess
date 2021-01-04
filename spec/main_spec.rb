require './main.rb'

describe "#start" do
  it "starts the game" do
    new_game = Chess.new
    expect(new_game).to have_attributes(:board => 'test')
  end
end