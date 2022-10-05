require 'faraday'
require 'json'

class Hangman
  ALLOWED_ATTEMPTS = 7
  WHITESPACE = ' '

  attr_accessor :word, :guessed_word, :guessed_letters, :used_letters

  def initialize
    response = Faraday.get('https://random-word-api.herokuapp.com/word')
    @word = JSON.parse(response.body).first.chars
    @guessed_word = ('*' * @word.length).chars
    @used_letters = []
    @guessed_letters = 0
  end

  def start_game
    puts("Hi. That's Hangman game. Let's remember rules.
          1. You have 7 lives.
          2. If the word doesn't contain your letter -> -1 live
          3. If you put the already used letter -> -1 live
          May the force be with you!\n\n")
    play_and_count_attempts == ALLOWED_ATTEMPTS ? (puts "\nYou lose :(") : (puts "\nYou win!")
    puts "Word was --- #{@word.join}"
  end

  private

  def play_and_count_attempts
    missed_letters = 0
    while missed_letters < ALLOWED_ATTEMPTS
      puts "Current word: #{@guessed_word.join(WHITESPACE)}"
      print 'Enter a letter to guess: '

      missed_letters = process_guess(gets.chomp, missed_letters)
      puts "--- Result after guess: #{@guessed_word.join(WHITESPACE)}"
      puts "--- Lives: #{ALLOWED_ATTEMPTS - missed_letters}\n\n"

      @guessed_letters == @word.size ? break : next
    end
    missed_letters
  end

  def process_guess(letter, missed_letters)
    letter_index = @word.each_index.select { |i| @word[i].eql? letter }
    if letter_index.empty? || @used_letters.include?(letter)
      puts '--- You missed. Try again.'
      missed_letters += 1
    else
      fill_guessed_word letter_index
      puts '--- Well done. Keep it up!'
    end
    used_letters.push letter
    missed_letters
  end

  def fill_guessed_word(letter_index)
    letter_index.each do |i|
      @guessed_word[i] = @word[i]
      @guessed_letters += 1
    end
  end
end

hangman = Hangman.new
hangman.start_game
