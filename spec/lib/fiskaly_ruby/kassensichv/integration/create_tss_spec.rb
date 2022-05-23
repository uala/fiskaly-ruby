# frozen_string_literal: true

RSpec.describe 'Create TSS' do
  subject(:create_tss) { FiskalyRuby::KassenSichV::TSS::Create.new(token: token, tss_id: tss_id) }

  let(:token) { FiskalyTesting.kassensichv_authenticate }

  context 'with valid data' do
    let(:tss_id) { ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id') }

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_create_ok' }
    it 'should create a TSS', vcr: vcr_options do
      expect(create_tss.call).to match(status: :ok, body: a_kind_of(Hash))
    end
  end

  context 'with invalid data' do
    let(:tss_id) { ENV.fetch('RSPEC_FISKALY_INVALID_TSS_ID', 'some_invalid_tss_id') }

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_create_error' }
    it "doesn't create a TSS", vcr: vcr_options do
      expect(create_tss.call).to match(status: :error, message: 'Bad Request', body: a_kind_of(Hash))
    end
  end
end
