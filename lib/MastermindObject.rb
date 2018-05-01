# Top-level object inherited by other mastermind game components
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

  def different_color(current_color)
    new_color = current_color
    new_color = random_color while new_color.eql? current_color
    new_color
  end
end