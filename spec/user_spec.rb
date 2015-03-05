require 'rspec'
require 'user'

describe User do
  subject { User.all.first }

  context 'seed file run' do

    it 'gives correct average karma for first user' do
      expect(subject.average_karma).to eq(1.5)
    end
  end
end
