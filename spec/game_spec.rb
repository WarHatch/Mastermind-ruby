require '~/Code_folder/the_odin_project/Mastermind/lib/game'

describe Board do
  subject do
    Board.new(true)
  end

  before(:each) do
    subject.input_code '1 1 1 2'
  end

  describe '#evaluate_guess' do
    it 'Given the correct guess should return all P[ositive] feedback' do
      expect(subject.evaluate_guess(%w[1 1 1 2])).to eql(%w[P P P P])
    end

    it 'Given the absolutely wrong guess should return all negative feedback' do
      expect(subject.evaluate_guess(%w[0 0 0 0])).to eql([nil, nil, nil, nil])
    end

    it 'When guessed the colour correctly in wrong position should return C[olor] feedback' do
      expect(subject.evaluate_guess(%w[2 0 0 1])).to eql(['C', 'C', nil, nil])
    end
  end

end
