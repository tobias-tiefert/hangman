class Player
  attr_accessor :wrong_guesses, :wrong_letters

  def initialize
    @wrong_guesses = 0
    @wrong_letters = ''
  end

  def guess
    puts '-------------------------------------------'
    puts 'Choose a letter'
    gets.chomp
  end
end
