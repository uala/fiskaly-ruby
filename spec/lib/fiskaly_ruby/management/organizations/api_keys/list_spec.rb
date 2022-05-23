RSpec.describe FiskalyRuby::Management::Organizations::ApiKeys::List do
  it 'inherits from "FiskalyRuby::Management::Base" class' do
    expect(described_class).to be < FiskalyRuby::Management::Base
  end

  describe '#call' do
    let(:token) do
      api_key = ENV.fetch('RSPEC_FISKALY_API_KEY', 'some_fiskaly_api_key')
      api_secret = ENV.fetch('RSPEC_FISKALY_API_SECRET', 'some_fiskaly_api_secret')
      authenticate_context = FiskalyRuby::KassenSichV::Authenticate.call(api_key: api_key, api_secret: api_secret)
      authenticate_context[:body]['access_token']
    end
    let(:organization_id) { ENV.fetch('RSPEC_FISKALY_ORGANIZATION_ID', 'some_organization_id') }
    let(:query) { { status: 'enabled' } }

    context 'with valid data' do
      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/api_key_list_ok' }
      it 'shows the tss', vcr: vcr_options do
        organization_retrieve = described_class.new(token: token, organization_id: organization_id, query: query)

        expect(organization_retrieve.call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end

    context 'with invalid data' do
      let(:token) { 'some_wrong_fiskaly_token' }

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/api_key_list_error' }
      it 'shows the tss', vcr: vcr_options do
        organization_retrieve = described_class.new(token: token, organization_id: organization_id, query: query)

        expect(organization_retrieve.call).to match(status: :error, message: 'Unauthorized', body: a_kind_of(Hash))
      end
    end
  end
end
