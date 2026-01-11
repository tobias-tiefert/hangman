class Computer
  attr_reader :secret_word

  def initialize
    @secret_word = File.readlines('google-10000-english-no-swears.txt').map(&:chomp).select do |word|
      word.length >= 5 && word.length <= 13
    end.sample
  end
end
