# frozen_string_literal: true

RSpec.describe FiskalyRuby::KassenSichV::Base do
  describe 'Base class' do
    it 'expect to inherit from "FiskalyRuby::BaseRequest" class' do
      expect(described_class).to be < FiskalyRuby::BaseRequest
    end
  end

  describe 'base_uri' do
    it 'should have a base uri' do
      expect(described_class.base_uri).to eq(
        ENV.fetch('FISKALY_KASSENSICHV_BASE_URL', 'https://kassensichv-middleware.fiskaly.com/api/v2')
      )
    end
  end
end
