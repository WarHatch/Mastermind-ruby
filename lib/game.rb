require_relative 'AI'

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
    guess = Array.new(@ai.guess)
    puts @answer.to_s
    if guess.eql? @answer
      @turns_passed += 1
      return true
    else
      evaluate_guess(guess)
      @ai.collect_results(@guesses[@turns_passed].feedback)
      @turns_passed += 1
      puts 'TRY AGAIN' if @turns_passed != TURNS
    end

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
    correctly_guessed = feedback_position(guess)
    # puts "Position feedback:\n#{@guesses[@turns_passed].feedback}"
    # puts "The guess after 'pulling out' the correct pegs:\n#{guess.to_s}"

    feedback_colors(guess, correctly_guessed)
    puts "Feedback:\n#{@guesses[@turns_passed].feedback}"
    @guesses[@turns_passed].feedback
  end

  # Adds CORRECT_POSITION pegs and returns positions that were guessed correctly
  def feedback_position(guess)
    correct_positions = Array.new(PEG_SPACES)
    guess.each.with_index do |peg, slot|
      if peg.eql? @answer[slot]
        @guesses[@turns_passed].add_feedback_peg CORRECT_POSITION
        guess[slot] = EMPTY
        correct_positions[slot] = CORRECT_POSITION
      end
    end
    correct_positions
  end

  def remove_correctly_guessed_pegs(correctly_guessed)
    remaining_answer = Array.new(@answer)

    answer_offset = 0
    for index in 0..@answer.length - 1
      if correctly_guessed[index] == CORRECT_POSITION
        remaining_answer.delete_at(index - answer_offset)
        answer_offset += 1
      end
      # puts "partial remaining answer: #{remaining_answer.to_s}"
    end
    remaining_answer
  end

  def feedback_colors(guess, correctly_guessed)
    # puts "remaining_guess: #{guess}"
    remaining_answer = remove_correctly_guessed_pegs(correctly_guessed)
    # puts "remaining_answer: #{remaining_answer}"

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

# puts '* * * M a s t e r m i n d * * *'
# game = Board.new(true)
# game.play(true)
