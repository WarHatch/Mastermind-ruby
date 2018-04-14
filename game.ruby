# FIXME: use require_relative to load code from AI.ruby
#require_relative 'AI.ruby'

class MastermindObject
  PEG_SPACES = 4
  TURNS = 12
  COLORS = ['1', '2', '3', '4', '5', '6'].freeze
  EMPTY = '0'.freeze
  CORRECT_POSITION = 'P'.freeze
  CORRECT_COLOR = 'C'.freeze

  def random_color
    COLORS.sample
  end
end

# Guesses and learns how to guess the code correctly
class AI < MastermindObject
  # TODO: use guessed spaces to check coours
  # TODO: if the computer has guessed the right color but the wrong position
  #       , its next guess will need to include that color somewhere
  def initialize
    @correct_position_colors = Array.new(PEG_SPACES) { EMPTY }
    @break_attempt = []
    @previous_result = nil
  end

  def guess
    if @previous_result.nil?
      @break_attempt.push random_guess
    else
      @break_attempt.push smart_guess
    end
    @previous_result = @break_attempt.last
  end

  def random_guess
    peg_guesses = []
    PEG_SPACES.times { peg_guesses.push(random_color) }
    peg_guesses
  end

  def smart_guess
    peg_guesses = []
    @correct_position_colors.each_with_index do |slot, index|
      if slot == EMPTY
        peg_guesses.push(random_color)
      else
        peg_guesses.push(@correct_position_colors[index])
      end
    end
    peg_guesses
  end
end

# Component for Board class
class BreakAttempt < MastermindObject
  attr_accessor :break_attempt
  attr_reader :feedback, :feedback_count

  def initialize
    @break_attempt = Array.new(PEG_SPACES)
    @feedback = Array.new(PEG_SPACES)
    @feedback_count = 0
  end

  def add_feedback_peg(feedback_type)
    @feedback[@feedback_count] = feedback_type
    @feedback_count += 1
  end
end

# Mastermind game board components and game sequence
class Board < MastermindObject
  def initialize(computer_generated)
    @guesses = Array.new(TURNS) { BreakAttempt.new }
    @answer = Array.new(PEG_SPACES)
    @turns_passed = 0
    @ai = AI.new

    computer_generated ? generate_code : input_code
    puts @answer.to_s
    puts 'START GUESSING'
  end

  def generate_code
    PEG_SPACES.times do |i|
      @answer[i - 1] = random_color
    end
  end

  def input_code
    puts "Codemaker, write #{PEG_SPACES} numbers from 0 to #{COLORS.length} separated by space.
0 represents an empty spot
1-6 represent colors"
    input = gets.split(' ')
    unless input.length == PEG_SPACES
      puts 'Incorrect input, try again'
      input = input_code
    end
    @answer = input
  end

  def computer_guess
    guess = guess(@ai.guess)
    puts "AI guesses: #{guess}"

    false
  end

  def player_guess
    print 'guess: '
    guess = gets.chomp.split(' ') # player guess is converted to array
    @guesses[@turns_passed].break_attempt = guess
    puts @guesses[@turns_passed].break_attempt.to_s
    puts @answer.to_s
    if guess.eql? @answer
      @turns_passed += 1
      return true
    else
      evaluate_guess(guess)
      @turns_passed += 1
      puts 'TRY AGAIN' if @turns_passed != TURNS
    end
    false
  end

  def evaluate_guess(guess)
    feedback_position(guess)
    puts "Position feedback:\n#{@guesses[@turns_passed].feedback}"
    # puts "The guess after 'pulling out' the correct pegs:\n#{guess.to_s}"

    feedback_colors(guess)
    puts "Final feedback:\n#{@guesses[@turns_passed].feedback}"
  end

  # Adds CORRECT_POSITION pegs and returns guess without the correctly answered pegs
  def feedback_position(guess)
    guess.each.with_index do |peg, slot|
      if peg.eql? @answer[slot]
        @guesses[@turns_passed].add_feedback_peg CORRECT_POSITION
        guess[slot] = EMPTY
      end
    end
    guess
  end

  def remove_guessed_answer_pegs(guess)
    remaining_answer = Array.new(@answer)

    answer_offset = 0
    for index in 0..guess.length - 1
      if guess[index] == EMPTY
        remaining_answer.delete_at(index - answer_offset)
        answer_offset += 1
      end
      # puts "partial remaining answer: #{remaining_answer.to_s}"
    end
    remaining_answer
  end

  def feedback_colors(guess)
    puts "remaining_guess: #{guess}"
    remaining_answer = remove_guessed_answer_pegs(guess)
    puts "remaining_answer: #{remaining_answer}"

    remaining_answer.each do |answer_peg|
      if index = guess.index(answer_peg)
        guess[index] = EMPTY
        @guesses[@turns_passed].add_feedback_peg CORRECT_COLOR
      end
    end
  end

  def play(player_braker)
    braker_won = false
    until braker_won || @turns_passed >= TURNS
      braker_won = player_braker ? player_guess : computer_guess
    end
    if braker_won
      puts 'Code braker won!'
    else
      puts 'Code maker won!'
    end

    braker_won
  end
end

puts '* * * M a s t e r m i n d * * *'
game = Board.new(true)
game.play(true)
