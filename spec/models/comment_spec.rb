require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#validation' do
    it 'should have valid factory' do
      expect(build :comment).to be_valid
    end
  end
end