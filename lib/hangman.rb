class Hangman
  attr_reader :turns

  def initialize
    @word = get_word
    @letters = Hash.new
    @turns = @word.length
    @incorrect = Array.new
  end

  def to_s
    state || "_ " * word.length
  end

  def inspect
    to_s
  end

  def save(filename)
    Dir.mkdir('saved') unless Dir.exists? 'saved'
    file = "saved/#{filename}.dat"

    File.open(file, 'wb') do |f|
      f.write Marshal.dump(self)
    end
  end

  def self.load(filename)
    file = "saved/#{filename}.dat"
    begin
      Marshal.load (File.binread(file))
    rescue
      puts "No such file!"
    end
  end

  def play(guess)
    unless turns == 0 || won?
      make_guess guess
    end
  end

  def wrong_guesses
    incorrect.join(', ')
  end

  def won?
    state == word
  end

  def get_secret_word
    word if turns == 0
  end

  private
    attr_accessor :word
    attr_writer :turns
    attr_accessor :state
    attr_accessor :incorrect

    def get_dict
      File.readlines("5desk.txt").select {|word| word.chomp.length.between?(5,12)}
    end

    def get_word
      get_dict.sample.chomp
    end

    def make_guess(guess)
      self.turns -= 1
      if guess.length == 1
        result = add_guess guess
        self.state = correct_letters
      else
        result = whole_guess guess
      end
      incorrect << guess unless result
      return result
    end

    def add_guess(letter)
      @letters[letter.downcase] = word.downcase.include?(letter)
    end

    def whole_guess(guess)
      self.state = word if guess == word
    end

    def correct_letters
      word.chars.collect {|letter| @letters[letter.downcase] ? letter : " _ "} * ''
    end
end
