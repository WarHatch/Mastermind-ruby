# The run file for this project
class Board
  PEG_SPACES = 4
  TURNS = 12
  COLORS = ['1', '2', '3', '4', '5', '6'].freeze
  EMPTY = '0'.freeze
  CORRECT_POSITION = 'P'.freeze
  CORRECT_COLOR = 'C'.freeze


  def initialize(computer_generated)
    @guesses = Array.new(TURNS)
    @feedback = Array.new(TURNS.times { Array.new(PEG_SPACES) })
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
    @guesses[@turns_passed] = guess
    puts guess.to_s
    puts @answer.to_s
    if guess.eql? @answer
      puts 'YOU WIN!'
    else
      check_guess(guess)
      puts 'TRY AGAIN'
    end

    @turns_passed += 1
  end

  #TODO: test without field assignment
  def check_guess(guess)
    @feedback[@turns_passed] = feedback_position(guess)

    puts "The board after 'pulling out' the correct pegs: #{guess.to_s}"
    puts "Feedback: #{@feedback[@turns_passed]}"

    @feedback[@turns_passed] = feedback_colors(guess)
    puts "Feedback: #{@feedback[@turns_passed]}"

  end

  def feedback_position(guess)
    feedback = Array.new(PEG_SPACES)
    # finds correct positions
    guess.each.with_index do |peg, slot|
      if peg.eql? @answer[slot]
        feedback[slot] = CORRECT_POSITION
      end
    end
    # "pulls out" correct pegs
    feedback.each.with_index do |feedback_peg, slot|
      if feedback_peg.eql? CORRECT_POSITION
        guess[slot] = EMPTY
      end
    end
    feedback
  end

  def feedback_colors(guess)
    feedback = @feedback[@turns_passed]

    occupied_slots = feedback.count { |slot| !slot.nil? }
    puts "Occupied slots: #{occupied_slots}"

    # removes already guessed peg slots and saves remaining guess for further checking
    remaining_answer = @answer.select.with_index { |_, index| feedback[index] != CORRECT_POSITION }
    puts "remaining_answer: #{remaining_answer}"
    puts "remaining_guess: #{guess}"

    remaining_answer.each do |answer_peg|
      if index = guess.index(answer_peg)
        guess[index] = EMPTY
        feedback[occupied_slots] = CORRECT_COLOR
      end
    end
    feedback
  end

end

puts '* * * M a s t e r m i n d * * *'
game = Board.new(true)
print 'guess: '
game.guess gets.chomp
