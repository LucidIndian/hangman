class Hangman
  # load Google dictionary
  # randomly select a word between 5 and 12 characters long for the secret word.
  attr_accessor :player 

  def initialize(player)
    @player = player 
  end

  

  def display_board
    puts "Board: _ _ _ _ _ "
    winner_check
  end

  def winner_check
    puts "Winner!"
  end
end  

class Player
  attr_accessor :name

  def initialize(name)
    @name = name 
  end

end

# Game Startup sequence
puts "Welcome to Tygh's Hangman game!"
sleep 0.5
puts "Player, enter your first name, then return"
name = gets.chomp
sleep 0.5
player = Player.new(name)
puts "Good luck, #{name}"
new_game = Hangman.new(player)
# read words txt file to array so we can pick random one
words_list = File.read('google-10000-english-no-swears.txt').split
secret_word = words_list.sample
puts "The Secret Word is #{secret_word}"
new_game.display_board