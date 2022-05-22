RSpec.describe 'Authenticate' do
  subject(:authenticate) { FiskalyRuby::KassenSichV::Authenticate.call(api_key: api_key, api_secret: api_secret) }

  let(:api_key) { ENV.fetch('RSPEC_FISKALY_API_KEY', 'some_fiskaly_api_key') }
  let(:api_secret) { ENV.fetch('RSPEC_FISKALY_API_SECRET', 'some_fiskaly_api_secret') }

  context 'with valid data' do
    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/authenticate_ok' }
    it 'receives an authorized response', vcr: vcr_options do
      expect(authenticate).to include(status: :ok, body: a_kind_of(Hash))
    end
  end

  context 'with invalid data' do
    let(:api_key) { ENV.fetch('RSPEC_FISKALY_INVALID_API_SECRET', 'some_invalid_fiskaly_api_key') }

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/authenticate_error' }
    it 'receives an unauthorized response', vcr: vcr_options do
      expect(authenticate).to eq({
        status: :error,
        message: 'Unauthorized',
        body: {
          'message' => 'Unauthorized',
          'status_code' => 401, 'error' => 'Unauthorized'
        }
      })
    end
  end
end
