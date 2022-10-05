class Hangman 
  
  require "yaml" # for saving and loading the game

  attr_accessor :player

  def initialize(player)
    @player = player
    @remaining_guesses = 6 # decrement w/ incorrect guesses later
    # secret word processing (Own method?)
      # load Google dictionary: read words txt file to array so we can pick random one
      @words_list = File.read('google-10000-english-no-swears.txt').split 
      # select a word between 5 and 12 characters long for the secret word.
      @filtered_words_list = @words_list.select { |word| word.length >= 5 && word.length <= 12 }
      @secret_word = @filtered_words_list.sample
      # create X num dashes to match chars on secret_word
      @secret_word_array = @secret_word.split("")
    puts "The Secret Word is \"#{@secret_word}\""
    # to solve for repeat letters, check this list as an
    # additional condition before/helping to update
    @remaining_letters_array = @secret_word_array
    # display board shows currrent state & starts matching secret_word length, with blanks
    @display_array = Array.new(@secret_word.length,"_")
    display_board()
    play()
  end

  def display_board()
    puts "Remaining guesses: #{@remaining_guesses}"
    puts "@display_array is #{@display_array}"
    # old: winner_check
  end

  # brought back the play method so I can show the updated/compelted board before declaring a winner and ending the game
  def play(guess = player.guess)
    if guess == "save"
      save_game # save game to YAML in the Hangman class
      return # do not keep playing, STOP
    elsif guess == "load"
      load_game
    elsif @remaining_letters_array.any?(guess) # false if correct guess already removed it
      # do not decrement guess, but update board
      # first, get indeices of all matches
      match_index_arr = @secret_word_array.each_index.select{|idx| @secret_word_array[idx] == guess} 
      # second, update display with the letter/guess at each index (works for duplicate letters)
      match_index_arr.each {|index| @display_array[index] = guess}
      # replace correct guess from remaining letters array with a non letter so it can't be guessed again
      match_index_arr.each {|index| @remaining_letters_array[index] = 0}
    elsif @remaining_letters_array.none?(guess)
      # decrement guesses since guess (letter) was not in secret word
      @remaining_guesses -= 1
    else 
      # nothing
    end
    winner_check
  end

  def winner_check
    if @remaining_guesses < 1
      puts "You're hung, you lose!"
      return
    # condition to prove player wins:
    elsif @display_array.none?("_") 
      puts "Congratulations, you saved yourself from being hung!"
      display_board()
      return
    else
      #keep playing
      display_board()
      play()
    end
  end


  def save_game # "to_yaml"
    puts "Saving game..."
    saved_game = YAML::dump(self)
    # puts saved_game # prints a MASSIVE OBJECT WITH ALL 8K WORDS
    fname = "hangman_saved_game.yml"
    gamefile = File.open(fname, "w")
    gamefile.puts saved_game
    gamefile.close
    puts "Game sucessfully saved!"
    # self == current Hangman instance (object)
  end

  def load_game # load game
    puts "Loading game..."
    # self == current Hangman instance (object)
    # load file
    gamefile = File.open("hangman_saved_game.yml", "r")
    contents = gamefile.read
    new_game = YAML::load( contents )
    puts "Game sucessfully loaded!"
    new_game.display_board
    new_game.play
  end


end # END class


class Player

  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def guess
    puts "What's your guess? (A-Z) or type \"SAVE\" or \"LOAD\"."
    # if SAVE, serialize the game class
    player_guess = gets.chomp
    if player_guess == "SAVE" || player_guess == "LOAD"
      # just let it ride
    elsif player_guess != "SAVE"
      # Ensure non "SAVE" guess is a letter (case insensitive) and not more than 1
      until /\p{L}/.match(player_guess) && player_guess.length == 1
      puts "Oops, please type one letter, A-Z"
      player_guess = gets.chomp
      end
      puts "player_guess is #{player_guess}"
    else
      puts "Error in guess method"
    end
    player_guess.downcase
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