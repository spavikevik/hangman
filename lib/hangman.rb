class Hangman
  attr_reader :turns

  def initialize(loaded = false)
    @word = get_word unless loaded
    @letters = Hash.new
    @turns = @word.length
  end

  def to_s
    state || "_ " * word.length
  end

  def inspect
    to_s
  end

  def save
  end

  def self.load
  end

  def play(letter)
    unless end?
      make_guess(letter)
      puts "\n#{state}\n\n#{turns} moves left."
    else
      puts "\n#{state}\n\nGame over."
    end
  end

  private
    attr_accessor :word
    attr_writer :turns
    attr_accessor :state

    def get_dict
      File.readlines("5desk.txt").select {|word| word.chomp.length.between?(5,12)}
    end

    def get_word
      get_dict.sample.chomp
    end

    def make_guess(letter)
      self.turns -= 1
      puts "Wrong letter!\n" unless add_guess(letter)
      self.state = correct_letters
    end

    def add_guess(letter)
      @letters[letter.downcase] = word.downcase.include?(letter)
    end

    def correct_letters
      word.chars.collect {|letter| @letters[letter.downcase] ? letter : " _ "} * ''
    end

    def end?
      state == word || turns == 0
    end
end
