# frozen_string_literal: true

RSpec.describe 'Update TSS' do
  subject(:update_tss) { FiskalyRuby::KassenSichV::TSS::Update.new(token: token, tss_id: tss_id, payload: payload) }

  let(:token) { FiskalyTesting.kassensichv_authenticate }
  let(:tss_id) { ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id') }

  context 'with valid data' do
    let(:payload) { { state: :UNINITIALIZED } }

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_update_ok' }
    it 'updates a TSS', vcr: vcr_options do
      expect(update_tss.call).to match(status: :ok, body: a_kind_of(Hash))
    end
  end

  context 'with invalid "tss_id" attribute' do
    let(:tss_id) { 'some_invalid_tss_id' }
    let(:payload) { { state: :UNINITIALIZED } }

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_update_error2' }
    it "doesn't create a TSS", vcr: vcr_options do
      expect(update_tss.call).to match(status: :error, message: 'Bad Request', body: a_kind_of(Hash))
    end
  end

  context 'with invalid "payload[:description]" parameter' do
    let(:invalid_description) { 'x' * 101 }
    let(:error_message) { /Invalid description for: #{invalid_description.inspect}/ }
    let(:payload) { { state: :UNINITIALIZED, description: invalid_description } }

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_update_error3' }
    it 'raises a RuntimeError exception', vcr: vcr_options do
      expect { update_tss.call }.to raise_exception(RuntimeError, error_message)
    end
  end
end
