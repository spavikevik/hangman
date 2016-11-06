require_relative 'lib/hangman'

def play_turn
  print "\nEnter a guess: "
  $game.play gets.chomp
end

def save_game
  print "\nEnter save name: "
  filename = gets.chomp
  $game.save(filename)
  puts "Game saved."
end

puts %{Welcome to Hangman!
Would you like to:
1. Start a new game
2. Load a saved game

}

option = gets.chomp.to_i
case option
when 1
  $game = Hangman.new
when 2
  print "\nEnter name of saved game: "
  $game = Hangman.load(gets.chomp)
else
  puts "You didn't choose any option! Exiting."
end

loop do
  if $game.won?
    puts "You won!"
    break
  elsif $game.turns == 0
    puts "You lost!"
    puts "Correct word was #{$game.get_secret_word}"
    break
  end
  puts "\n#{$game}\n"
  puts "\nWrong: #{$game.wrong_guesses}" if $game.wrong_guesses.length > 0
  puts  "#{$game.turns} turns remaining."
  print "\n(s)ave game or (p)lay next turn: "
  option = gets.chomp
  case option
  when "s"
    save_game
    puts "Exiting."
    break
  when "p"
    play_turn
  else
    puts "You didn't choose any option! Assuming you want to continue playing."
    play_turn
  end
end
