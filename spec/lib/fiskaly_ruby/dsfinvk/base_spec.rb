RSpec.describe FiskalyRuby::DSFinVK::Base do
  describe 'Base class' do
    it 'expect to inherit from "FiskalyRuby::BaseRequest" class' do
      expect(described_class).to be < FiskalyRuby::BaseRequest
    end
  end

  describe 'base_uri' do
    it 'should have a base uri' do
      expect(described_class.base_uri).to eq(
        ENV.fetch('FISKALY_DSFINVK_BASE_URL', 'https://dsfinvk.fiskaly.com/api/v1')
      )
    end
  end
end
