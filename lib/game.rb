class Game
  MAX_WRONG_GUESSES = 12

  def initialize
    @winner = nil
    ask_mode
  end

  private

  def ask_mode
    puts 'To start a new game press n to load a game press l'
    mode = gets.chomp

    if mode == 'l'
      load_game
    else
      start_game
    end
  end

  def start_game
    @computer = Computer.new
    @player = Player.new
    @player_guess = initialize_player_guess(@computer.secret_word)
    play_game
  end

  def initialize_player_guess(word)
    feedback = ''
    word.length.times do
      feedback += '*'
    end
    feedback
  end

  def play_game
    while @winner.nil?
      display_prompt
      update_result(@player.guess)
      check_result
    end
  end

  def display_prompt
    puts ' '
    puts '-------------------------------------------'
    puts "Can you guess the word? #{@player_guess}"
    puts '-------------------------------------------'
    puts "Wrong characters so far: #{@player.wrong_letters}"
    puts "Wrong guesses so far: #{@player.wrong_guesses} of #{MAX_WRONG_GUESSES}"
    puts "To save the current game write 'save' "
  end

  def update_result(letter)
    if letter.length > 1
      save_game
    elsif @computer.secret_word.include? letter
      update_player_guess(letter)
    else
      @player.wrong_guesses += 1
      @player.wrong_letters += "#{letter}, "
    end
  end

  def update_player_guess(letter)
    @computer.secret_word.chars.each_with_index do |character, index|
      next unless character == letter

      @player_guess = if index == 0
                        letter + @player_guess[1..(@player_guess.length - 1)]
                      elsif index == @computer.secret_word.length - 1
                        @player_guess[0..(@player_guess.length - 2)] + letter
                      else
                        @player_guess[0..(index - 1)] + letter + @player_guess[(index + 1)..(@player_guess.length - 1)]
                      end
    end
  end

  def check_result
    if @player.wrong_guesses == MAX_WRONG_GUESSES
      @winner = @computer
      puts 'You lost the game!'
      puts @computer.secret_word
    elsif @computer.secret_word == @player_guess
      @winner = @player
      puts 'You won the game!'
      puts @computer.secret_word
    end
  end

  def save_game
    puts 'Saving your current game'
    savegame = {
      secret_word: @computer.secret_word,
      wrong_guesses: @player.wrong_guesses,
      wrong_letters: @player.wrong_letters,
      player_guess: @player_guess
    }
    saved_game = File.new 'saved_game.yml', 'w'
    saved_game.puts YAML.dump(savegame).to_s
    saved_game.close
    @winner = 'saved'
  end

  def load_game
    loaded_file = File.open('saved_game.yml')
    loaded_game = ''
    while line = loaded_file.gets
      loaded_game += line
    end
    loaded_game = YAML.load(loaded_game)
    puts loaded_game[:secret_word]
    @computer = Computer.new(loaded_game[:secret_word])
    @player = Player.new(loaded_game[:wrong_guesses], loaded_game[:wrong_letters])
    @player_guess = loaded_game[:player_guess]
    play_game
  end
end
