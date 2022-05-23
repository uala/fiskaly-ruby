RSpec.describe FiskalyRuby::DSFinVK::Authenticate do
  let(:api_key) { ENV.fetch('RSPEC_FISKALY_API_KEY', 'some_fiskaly_api_key') }
  let(:api_secret) { ENV.fetch('RSPEC_FISKALY_API_SECRET', 'some_fiskaly_api_secret') }

  let(:authenticate) { described_class.new(api_key: api_key, api_secret: api_secret) }
  let(:authenticate_call) { described_class.call(api_key: api_key, api_secret: api_secret) }

  it 'inherits from "FiskalyRuby::DSFinVK::Base" class' do
    expect(described_class).to be < FiskalyRuby::DSFinVK::Base
  end

  describe '.call' do
    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/authenticate_ok' }
    it 'receives an authorized response', vcr: vcr_options do
      expect(authenticate_call).to include(status: :ok, body: a_kind_of(Hash))
    end

    context 'with invalid credentials' do
      let(:api_key) { ENV.fetch('RSPEC_FISKALY_INVALID_API_KEY', 'some_invalid_fiskaly_api_key') }

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/authenticate_error' }
      it 'receives an unauthorized response', vcr: vcr_options do
        expect(authenticate_call).to eq(
          {
            status: :error,
            message: 'Unauthorized',
            body: {
              'message' => 'Invalid credentials',
              'status_code' => 401,
              'error' => 'Unauthorized'
            }
          }
        )
      end
    end
  end

  describe '#call' do
    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/authenticate_ok' }
    it 'receives an authorized response', vcr: vcr_options do
      expect(authenticate.call).to include(status: :ok, body: a_kind_of(Hash))
    end

    context 'with invalid credentials' do
      let(:api_key) { ENV.fetch('RSPEC_FISKALY_INVALID_API_SECRET', 'some_invalid_fiskaly_api_key') }

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/authenticate_error' }
      it 'receives an unauthorized response', vcr: vcr_options do
        expect(authenticate.call).to eq(
          {
            status: :error,
            message: 'Unauthorized',
            body: {
              'message' => 'Invalid credentials',
              'status_code' => 401,
              'error' => 'Unauthorized'
            }
          }
        )
      end
    end
  end
end
