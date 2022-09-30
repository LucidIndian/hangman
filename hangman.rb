class Hangman 
  # load Google dictionary
  # randomly select a word between 5 and 12 characters long for the secret word.
  attr_accessor :player

  def initialize(player)
    @player = player
    @remaining_guesses = 6 # decrement
    # secret word processing
    # read words txt file to array so we can pick random one
    @words_list = File.read('google-10000-english-no-swears.txt').split 
    # between 5 and 12 characters long
    @filtered_words_list = @words_list.select { |word| word.length >= 5 && word.length <= 12 }
    @secret_word = @filtered_words_list.sample
    # create X num dashes to match chars on secret_word
    @secret_word_array = @secret_word.split("")
    puts "The Secret Word is \"#{@secret_word}\""
    # to solve for repeat letters, check this list as an
    # additional condition before/helping to update
    @remaining_letters_array = @secret_word_array
    # display board shows currrent state and
    # starts to match secret word length, with blanks
    @display_array = Array.new(@secret_word.length,"_")
    display_board()
    play()
  end

  # brought back the play method so I can show the updated/compelted board before declaring a winner and ending the game
  def play(letter = player.guess)
    if @remaining_letters_array.any?(letter) # false if correct guess already removed it
      # do not decrement guess, but update board
      # first, get indeices of all matches
      match_index_arr = @secret_word_array.each_index.select{|idx| @secret_word_array[idx] == letter} 
      # second, update display with the letter/guess at each index (works for duplicate letters)
      match_index_arr.each {|index| @display_array[index] = letter}
      # replace correct guess from remaining letters array with a non letter so it can't be guessed again
      match_index_arr.each {|index| @remaining_letters_array[index] = 0}
    else
      # decrement guesses since guess (letter) was not in secret word
      @remaining_guesses = @remaining_guesses - 1
    end
    display_board
    winner_check
  end

  def display_board()
    puts "Remaining guesses: #{@remaining_guesses}"
    puts "@display_array is #{@display_array}"
  end

  def winner_check
    if @remaining_guesses == 0
      puts "You're hung, #{player.name} loses!"
      return
    # condition to prove player wins:
    elsif @display_array.none?("_") 
      puts "Congratulations, #{player.name}, you saved yourself from being hung!"
      return
    else
      #keep playing
      play()
    end
  end
end # END class

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
    # puts "player_guess class is #{player_guess.class}"
    puts "player_guess is #{player_guess}"
    player_guess.downcase # to make our match-checker work in the `play` method
  end

end # END class

# Game Startup sequence
puts "Welcome to Tygh's Hangman game!"
sleep 0.5
puts "Player, enter your first name, then \"return\""
name = gets.chomp
sleep 0.5
player = Player.new(name)
puts "Good luck, #{name}"
new_game = Hangman.new(player)