class Hangman 
  # load Google dictionary
  # randomly select a word between 5 and 12 characters long for the secret word.
  attr_accessor :player

  def initialize(player)
    @player = player
    @remaining_guesses = 6 # decrement
    
    # secret word precessing
    # read words txt file to array so we can pick random one
    @words_list = File.read('google-10000-english-no-swears.txt').split 
    # between 5 and 12 characters long
    @filtered_words_list = @words_list.select { |word| word.length >= 5 && word.length <= 12 }
    @secret_word = @filtered_words_list.sample
    # create X num dashes to match chars on secret_word
    @secret_word_array = @secret_word.split("")
    puts "The Secret Word is #{@secret_word}"
    # p secret_word_array
    # display_array =  
    display_board()
  end

  def display_board()
    puts "Remaining guesses: #{@remaining_guesses}"
    puts "Board: _ _ _ _ _ "
    play
  end

  def play(letter = player.guess)
    # puts "the letter class is #{letter.class}"
    winner_check
  end

  def winner_check
    @remaining_guesses = @remaining_guesses - 1
    if @remaining_guesses == 0
      puts "You're hung, #{player.name} loses!"
    else
      #keep playing
 
      display_board()
    end   
  end
end  

class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def guess
    puts "#{self.name}, what's your guess? (A-Z)"
      player_guess = gets.chomp
      # Ensure guess is a letter (case insensitive) and not more than 1
      until /\p{L}/.match(player_guess) && player_guess.length == 1 
        puts "Oops, please type one letter, A-Z"
        player_guess = gets.chomp
      end
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