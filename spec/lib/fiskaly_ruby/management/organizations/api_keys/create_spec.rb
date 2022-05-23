# frozen_string_literal: true

RSpec.describe FiskalyRuby::Management::Organizations::ApiKeys::Create do
  let(:api_key) { ENV.fetch('RSPEC_FISKALY_API_KEY', 'some_fiskaly_api_key') }
  let(:api_secret) { ENV.fetch('RSPEC_FISKALY_API_SECRET', 'some_fiskaly_api_secret') }
  let(:organization_id) { ENV.fetch('RSPEC_FISKALY_ORGANIZATION_ID', 'some_fiskaly_organization_id') }
  let(:managed_by_organization_id) do
    ENV.fetch('RSPEC_FISKALY_MANAGED_BY_ORGANIZATION_ID', 'some_fiskaly_managed_by_organization_id')
  end

  describe 'NAME_REGEXP' do
    let(:char) { 'x' }

    context 'with a valid name' do
      it 'matches the regexp' do
        expect(described_class::NAME_REGEXP.match?(char * 3)).to be_truthy
        expect(described_class::NAME_REGEXP.match?(char * 30)).to be_truthy
      end
    end

    context 'with an invalid name' do
      it "doesn't match the regexp" do
        expect(described_class::NAME_REGEXP.match?(char * 1)).to be_falsey
        expect(described_class::NAME_REGEXP.match?(char.upcase * 3)).to be_falsey
        expect(described_class::NAME_REGEXP.match?(char * 31)).to be_falsey
      end
    end
  end

  describe 'STATUSES' do
    context 'with a valid status' do
      it 'is included in STATUSES' do
        expect(described_class::STATUSES.include?(:enabled)).to be_truthy
        expect(described_class::STATUSES.include?(:disabled)).to be_truthy
      end
    end

    context 'with an invalid status' do
      it 'is not included in STATUSES' do
        expect(described_class::STATUSES.include?(:invalid_status)).to be_falsey
      end
    end
  end

  describe '#token' do
    it 'returns "token" attribute' do
      expect(described_class.new(token: 'some_token', organization_id: 1)).to respond_to(:organization_id)
    end
  end

  describe '#call' do
    context 'with an invalid name parameter' do
      let(:payload) do
        {
          name: 'Main',
          status: :enabled,
          managed_by_organization_id: 1,
          metadata: {}
        }
      end
      let(:api_key) do
        described_class.new(token: 'some_token', organization_id: 1, payload: payload)
      end

      let(:error_message) do
        "Invalid name for: #{api_key.payload[:name].inspect}, please use a lowercase 3 to 30 characters string"
      end

      it 'raises a RuntimeError exception' do
        expect { api_key.call }.to raise_error(RuntimeError, error_message)
      end
    end

    context 'with an invalid status parameter' do
      let(:payload) do
        {
          name: 'main',
          status: 'foo',
          managed_by_organization_id: 1,
          metadata: {}
        }
      end
      let(:api_key) do
        described_class.new(token: 'some_token', organization_id: 1, payload: payload)
      end

      let(:error_message) { "Invalid status for: #{api_key.payload[:status].inspect}" }

      it 'raises a RuntimeError exception' do
        expect { api_key.call }.to raise_error(RuntimeError, error_message)
      end
    end

    context 'with an invalid metadata parameter' do
      let(:payload) do
        {
          name: 'main',
          status: :enabled,
          managed_by_organization_id: 1,
          metadata: 'some_invalid_metadata'
        }
      end
      let(:api_key) do
        described_class.new(token: 'some_token', organization_id: 1, payload: payload)
      end

      let(:error_message) do
        <<~ERROR_MESSAGE
          Invalid 'metadata' type: #{api_key.payload[:metadata].class.inspect}, please use a Hash.
          You can use this parameter to attach custom key-value data to an object.
          Metadata is useful for storing additional, structured information on an object.
          Note: You can specify up to 20 keys,
          with key names up to 40 characters long and values up to 500 characters long.
        ERROR_MESSAGE
      end

      it 'raises a RuntimeError exception' do
        expect { api_key.call }.to raise_error(RuntimeError, error_message)
      end
    end

    context 'with valid data' do
      let(:payload) do
        {
          name: 'name',
          status: :enabled,
          organization_id: organization_id,
          managed_by_organization_id: managed_by_organization_id,
          metadata: {}
        }
      end

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/management/org_api_keys_create_ok' }
      it 'creates an ApiKey', vcr: vcr_options do
        # NOTE: to regenerate this VCR cassette the organization API key must not exist
        authenticate_context = FiskalyRuby::Management::Authenticate.call(api_key: api_key, api_secret: api_secret)
        access_token = authenticate_context[:body]['access_token']
        create_api_key = described_class.new(token: access_token, organization_id: organization_id, payload: payload)

        expect(create_api_key.call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end

    context 'with invalid data' do
      let(:invalid_organization_id) do
        # NOTE: fake organization UUID
        ENV.fetch('RSPEC_FISKALY_INVALID_ORGANIZATION_ID', 'a2aa222a-2222-22a2-2222-a22a2aa222a2')
      end
      let(:payload) do
        {
          name: 'main',
          status: :enabled,
          organization_id: invalid_organization_id,
          managed_by_organization_id: managed_by_organization_id,
          metadata: {}
        }
      end

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/management/org_api_keys_create_error' }
      it "doesn't create an ApiKey", vcr: vcr_options do
        authenticate_context = FiskalyRuby::Management::Authenticate.call(api_key: api_key, api_secret: api_secret)
        access_token = authenticate_context[:body]['access_token']
        create_api_key = described_class.new(token: access_token, organization_id: invalid_organization_id, payload: payload)

        expect(create_api_key.call).to match(status: :error, message: 'Not Found', body: a_kind_of(Hash))
      end
    end
  end

  describe '#body' do
    let(:payload) do
      {
        name: 'main',
        status: :enabled,
        managed_by_organization_id: 1
      }
    end
    let(:create_api_key) do
      described_class.new(token: 'some_token', organization_id: 1, payload: payload)
    end

    it 'returns a JSON' do
      expect(create_api_key.body).to be_json_eql({
        name: 'main',
        status: :enabled,
        managed_by_organization_id: 1
      }.to_json)
    end
  end
end
