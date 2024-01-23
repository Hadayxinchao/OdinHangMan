require_relative "hangman_art.rb"

class Game
  def initialize
    @word = load_word
    @result_word = "_ " * @word.length
    @lives = 6
  end
  attr_accessor :word, :result_word, :lives

  def load_word
    file_data = File.read("google-10000-english-no-swears.txt").split
    words = file_data.select do |word|
      word.length.between?(5, 12)
    end
    random_word = words.sample
  end
  
  def load_game?
    puts "Do you want to open saved game?(Yes or No)"
    answer = gets.chomp.downcase
    return true if answer == "yes"
    return false
  end

  def play
    puts "Welcome to HangMan"
    load_game if load_game?
    puts "Here is the secret word: "
    puts "#{@word}"
    loop do
      puts "\n#{@result_word}"
      if save_game?
        save_game
        break
      else
        guess_word
      end

      if check_result == "Win"
        puts "You're right! The answer is #{@word}"
        break
      elsif check_result == "Lose"
        puts "You're run out of lives. The answer is #{@word}. Good luck!"
        break
      end
    end
  end

  def save_game?
    puts "Do you wanna save the game:(Yes or Othercase)"
    answer = gets.chomp
    return true if answer == "yes"
    return false
  end

  def save_game
    File.open('save_game.txt', 'w') do |file|
      file.write("#{@word}\n")
      file.write("#{@result_word}\n")
      file.write("#{@lives}\n")
    end
  end

  def load_game
    File.open('save_game.txt', 'r') do |file|
      @word = file.gets.chomp
      @result_word = file.gets.chomp
      @lives = file.gets.to_i
    end
  end

  def check_result
    return "Win" unless @result_word.include?("_")
    return "Lose" if @lives == 0
    nil
  end

  def guess_word
    print "Make a guess: "
    guess = gets.chomp.downcase
    if guess.length != 1
      puts "Invalid Length of Character"
    else
      correct = false
      @word.split("").each_with_index do |char, i|
        if char == guess
          @result_word[i*2] = char
          correct = true
        end
      end
      if !correct
        @lives -= 1
        puts "\nIncorrect, live: #{@lives}"
        puts STAGES[@lives - 1]
      end
    end
  end

  def self.replay?
    puts "\nWanna Play Again? (\"Yes\" for continue, \"No\" for stop)"
    answer = gets.chomp.downcase
    return true if answer == "yes"
    nil
  end
end

ready = false
until ready
  system "clear"
  Game.new.play
  ready = true unless Game.replay?
end

puts "Goodbye, have a good day with Odin!"