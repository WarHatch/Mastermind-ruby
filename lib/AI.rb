require_relative 'MastermindObject'

# Guesses and learns how to guess the code correctly
class AI < MastermindObject
  # TODO: if the computer has guessed the right color but the wrong position
  #       , its next guess will need to include that color somewhere
  def initialize
    @correct_position_colors = Array.new(PEG_SPACES) { EMPTY }
    @break_attempt = []
    @previous_results = []
    @all_colors_guessed = false
  end

  def guess
    new_guess = []
    if @previous_results.length < 2
      new_guess = random_guess
    else
      new_guess = smart_guess
    end
    puts "Computer guesses:\n#{new_guess.to_s}"
    @break_attempt.push new_guess
    new_guess
  end

  def random_guess
    peg_guesses = []
    PEG_SPACES.times { peg_guesses.push(random_color) }
    peg_guesses
  end

  def evaluate_last2_by_nonnil # FIXME: in progress
    puts "--- previous result evaluation"
    first_guess_miss = @previous_results[-2].count(nil)
    second_guess_miss = @previous_results[-1].count(nil)
    puts "first_guess_miss: #{first_guess_miss} with guess: #{@break_attempt[-2].to_s}"
    puts "secon_guess_miss: #{second_guess_miss} with guess: #{@break_attempt[-1].to_s}"

    good_result = Array.new(@previous_results[-1])
    good_guess = Array.new(@break_attempt[-1])
    earlier_better = second_guess_miss <=> first_guess_miss
    puts "earlier guess more accurate?: #{earlier_better}"
    if earlier_better == 1
      good_result = @previous_results[-2]
      good_guess = @break_attempt[-2]

      # TODO: maybe add special case when both results are equally good
    end
    misses = good_result.count(nil)
    puts "Better guess: #{good_guess.to_s} with #{misses} misses"
    if misses > 0
      # TODO: add check to not repeat guesses
      misses.times do
        random_index = rand(0..good_guess.length - 1)
        good_guess[random_index] = different_color(good_guess[random_index])
      end
      puts "Remixed guess: #{good_guess.to_s}"

    else
      # TODO: randomize answer - use correct position flag
      puts "*** Not handled yet: randomize answer - use correct position flag"
    end

    puts "evaluation end ---"
    good_guess
  end

  def smart_guess
    evaluate_last2_by_nonnil
  end

  def collect_results(feedback)
    @previous_results.push feedback
  end
end
