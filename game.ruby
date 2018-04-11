# Component for Board class
class BreakAttempt
  attr_accessor :break_attempt
  attr_reader :feedback, :feedback_count

  def initialize(peg_spaces)
    @break_attempt = Array.new(peg_spaces)
    @feedback = Array.new(peg_spaces)
    @feedback_count = 0
  end

  def add_feedback_peg(feedback_type)
    @feedback[@feedback_count] = feedback_type
    @feedback_count += 1
  end
end

# Mastermind game board components and game sequence
class Board
  PEG_SPACES = 4
  TURNS = 12
  COLORS = ['1', '2', '3', '4', '5', '6'].freeze
  EMPTY = '0'.freeze
  CORRECT_POSITION = 'P'.freeze
  CORRECT_COLOR = 'C'.freeze

  def initialize(computer_generated)
    @guesses = Array.new(TURNS) { BreakAttempt.new(PEG_SPACES) }
    @answer = Array.new(PEG_SPACES)
    @turns_passed = 0

    if computer_generated
      generate_code
    else
      input_code
    end
    puts @answer.to_s
    puts 'START GUESSING'
  end

  def generate_code
    PEG_SPACES.times do |i|
      @answer[i - 1] = rand(1..6).to_s
    end
  end

  def input_code
    puts "Codemaker, write 4 numbers from 0 to 6 separated by space.
    0 represents an empty spot
    1-6 represent colors"
    raise NotImplementedError
  end

  def guess(guess_string)
    guess = guess_string.split(' ')
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
    # puts "Feedback:\n#{@guesses[@turns_passed].feedback}"
    # puts "The board after 'pulling out' the correct pegs:\n#{guess.to_s}"

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

  def feedback_colors(guess)
    remaining_answer = @answer
    # puts "remaining_guess: #{guess}"

    remaining_answer.each do |answer_peg|
      if index = guess.index(answer_peg)
        guess[index] = EMPTY
        @guesses[@turns_passed].add_feedback_peg CORRECT_COLOR
      end
    end
  end

  def play
    braker_won = false
    until braker_won || @turns_passed >= TURNS
      print 'guess: '
      braker_won = guess gets.chomp
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
game.play
