RSpec.describe FiskalyRuby::Management::Base do
  describe 'Base class' do
    it 'expect to inherit from "FiskalyRuby::BaseRequest" class' do
      expect(described_class).to be < FiskalyRuby::BaseRequest
    end
  end

  describe 'base_uri' do
    it 'should have a base uri' do
      expect(described_class.base_uri).to eq(
        ENV.fetch('FISKALY_MANAGEMENT_BASE_URL', 'https://dashboard.fiskaly.com/api/v0')
      )
    end
  end

  describe 'COUNTRY_CODES' do
    it 'should contain 3 uppercased characters string' do
      expect(described_class::COUNTRY_CODES.all? { |code| code == code.upcase && code.length == 3 }).to be_truthy
    end
  end
end
