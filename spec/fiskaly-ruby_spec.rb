# frozen_string_literal: true

RSpec.describe FiskalyRuby do
  describe 'VERSION' do
    it 'has a version number' do
      expect(FiskalyRuby::VERSION).not_to be nil
    end
  end
end
