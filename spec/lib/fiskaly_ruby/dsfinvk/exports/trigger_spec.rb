RSpec.describe FiskalyRuby::DSFinVK::Exports::Trigger do
  it 'inherits from "FiskalyRuby::DSFinVK::Base" class' do
    expect(described_class).to be < FiskalyRuby::DSFinVK::Base
  end

  describe '#required_payload_attributes' do
    subject(:required_payload_attributes) { trigger.required_payload_attributes }

    let(:trigger) { described_class.new(token: 'some_token') }

    it { is_expected.to eq(%i(start_date end_date)) }
  end

  describe '#optional_payload_attributes' do
    subject(:optional_payload_attributes) { trigger.optional_payload_attributes }

    let(:trigger) { described_class.new(token: 'some_token') }

    it { is_expected.to eq(%i(client_id metadata)) }
  end

  describe '#call' do
    subject(:call) { described_class.new(token: access_token, export_id: export_id, payload: payload).call }

    let(:api_key) { ENV.fetch('RSPEC_FISKALY_API_KEY', 'some_fiskaly_api_key') }
    let(:api_secret) { ENV.fetch('RSPEC_FISKALY_API_SECRET', 'some_fiskaly_api_secret') }
    let(:access_token) do
      authenticate_context = FiskalyRuby::DSFinVK::Authenticate.call(api_key: api_key, api_secret: api_secret)
      authenticate_context[:body]['access_token']
    end
    let(:export_id) { ENV.fetch('RSPEC_FISKALY_TSS_EXPORT_ID', '44dd4d44-d4d4-44d4-4dd4-4ddd4d4ddd44') }
    let(:payload) { { start_date: ::Time.current.yesterday.to_i, end_date: ::Time.current.to_i } }

    context 'with valid data' do
      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/exports_trigger_ok' }
      it 'triggers an export', vcr: vcr_options do
        attrs = {
          'state' => 'PENDING',
          'time_request' => a_kind_of(Integer),
          'time_expiration' => a_kind_of(Integer),
          'sign_api_version' => a_kind_of(Integer)
        }

        expect(call).to match(status: :ok, body: a_hash_including(attrs))
      end
    end

    context 'with invalid data' do
      let(:export_id) { ENV.fetch('RSPEC_FISKALY_EXPORT_ID', 'some-invalid-id') }

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/exports_trigger_error' }
      it 'returns a schema validation error', vcr: vcr_options do
        error = 'Bad Request'
        attrs = {
          'code' => 'E_FAILED_SCHEMA_VALIDATION',
          'error' => error,
          'status_code' => 400,
          'message' => a_kind_of(String)
        }

        expect(call).to match(status: :error, message: error, body: a_hash_including(attrs))
      end
    end
  end
end
