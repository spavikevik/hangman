class Hangman
  attr_reader :turns
  attr_reader :incorrect

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
    unless turns == 0 || game_won?
      puts "Wrong guess!" unless make_guess guess
      puts "\n#{to_s}\n\nWrong guesses: #{incorrect.join(', ')}\n#{turns} moves left."
      puts "\nGame over!\nCorrect word was: #{word}\n" if turns == 0 || game_won?
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

    def game_won?
      state == word
    end
end
