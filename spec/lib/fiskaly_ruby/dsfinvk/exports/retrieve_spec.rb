RSpec.describe FiskalyRuby::DSFinVK::Exports::Retrieve do
  context 'unit tests' do
    let(:export_retrieve) { described_class.new(token: 'some_token', export_id: 'some_export_id') }

    describe 'Base class' do
      it 'expect to inherit from "FiskalyRuby::DSFinVK::Base" class' do
        expect(described_class).to be < FiskalyRuby::DSFinVK::Base
      end
    end

    describe '#call' do
      context 'with valid params' do
        let(:response) { instance_double(Net::HTTPOK, body: { foo: :bar }.to_json) }
        let(:ok_request) { instance_double(HTTParty::Response, success?: true, response: response) }

        before do
          allow(described_class).to receive(:get).and_return(ok_request)
        end

        it 'succeeded' do
          expect(described_class).to receive(:get).and_return(ok_request)
          expect(export_retrieve.call).to match(
            {
              status: :ok,
              body: JSON.parse(ok_request.response.body)
            }
          )
        end
      end

      context 'with invalid params' do
        let(:response) { instance_double(Net::HTTPBadRequest, message: 'Bad Request', body: {}.to_json) }
        let(:error_request) { instance_double(HTTParty::Response, success?: false, response: response) }

        before do
          allow(described_class).to receive(:get).and_return(error_request)
        end

        it 'failed' do
          expect(described_class).to receive(:get).and_return(error_request)
          expect(export_retrieve.call).to match(
            {
              status: :error,
              message: error_request.response.message,
              body: JSON.parse(error_request.response.body)
            }
          )
        end
      end
    end
  end

  context 'integration tests' do
    let(:export_retrieve) { described_class.new(token: token, export_id: export_id).call }
    let(:token) do
      api_key = ENV.fetch('RSPEC_FISKALY_API_KEY', 'some_fiskaly_api_key')
      api_secret = ENV.fetch('RSPEC_FISKALY_API_SECRET', 'some_fiskaly_api_secret')
      authenticate_context = FiskalyRuby::DSFinVK::Authenticate.call(api_key: api_key, api_secret: api_secret)
      authenticate_context.dig(:body, 'access_token')
    end

    context 'with existing export' do
      let(:export_id) { ENV.fetch('RSPEC_FISKALY_DSFINVK_EXPORT_ID', 'some_dsfinvk_export_id') }

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/exports_retrieve_ok' }
      it 'retrieves an export file', :aggregate_failures, vcr: vcr_options do
        expect(export_retrieve[:status]).to eq(:ok)
      end
    end

    context 'with not existing export' do
      let(:export_id) { 'some_not_existing_export_id' }

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/exports_retrieve_error' }
      it 'retrieves an export file', :aggregate_failures, vcr: vcr_options do
        expect(export_retrieve[:status]).to eq(:error)
        expect(export_retrieve[:message]).to eq('Bad Request')
      end
    end
  end
end
