RSpec.describe FiskalyRuby::DSFinVK::CashRegisters::Retrieve do
  it 'inherits from "FiskalyRuby::DSFinVK::Base" class' do
    expect(described_class).to be < FiskalyRuby::DSFinVK::Base
  end

  describe '#call' do
    let(:token) do
      api_key = ENV.fetch('RSPEC_FISKALY_API_KEY', 'some_fiskaly_api_key')
      api_secret = ENV.fetch('RSPEC_FISKALY_API_SECRET', 'some_fiskaly_api_secret')
      authenticate_context = FiskalyRuby::KassenSichV::Authenticate.call(api_key: api_key, api_secret: api_secret)
      authenticate_context[:body]['access_token']
    end
    let(:client_id) { ENV.fetch('RSPEC_FISKALY_CLIENT_ID', 'some_client_id') }

    context 'with valid data' do
      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/cash_register_retrieve_ok' }
      it 'shows the tss', vcr: vcr_options do
        cash_register_retrieve = described_class.new(token: token, client_id: client_id)

        expect(cash_register_retrieve.call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end

    context 'with invalid data' do
      let(:token) { 'some_wrong_fiskaly_token' }

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/cash_register_retrieve_error' }
      it 'shows the tss', vcr: vcr_options do
        cash_register_retrieve = described_class.new(token: token, client_id: client_id)

        expect(cash_register_retrieve.call).to match(status: :error, message: 'Unauthorized', body: a_kind_of(Hash))
      end
    end
  end
end
