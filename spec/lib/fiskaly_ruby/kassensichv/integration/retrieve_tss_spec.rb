# frozen_string_literal: true

RSpec.describe 'Retrieve TSS' do
  subject(:retrieve_tss) { FiskalyRuby::KassenSichV::TSS::Retrieve.new(token: token, tss_id: tss_id).call }

  let(:token) { FiskalyTesting.kassensichv_authenticate }
  let(:tss) { FiskalyTesting.kassensichv_find_or_create_tss(token: token) }
  let(:tss_id) { tss.tss_id }

  context 'with valid data' do
    include_context 'setup Fiskaly env'

    before { tss }

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_retrieve_ok' }
    it 'retrives the tss data', vcr: vcr_options do
      expect(retrieve_tss).to match(status: :ok, body: a_kind_of(Hash))
    end
  end

  context 'with invalid data' do
    include_context 'setup Fiskaly env'

    let(:token) { 'some_wrong_fiskaly_token' }

    before { tss }

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_retrieve_error' }
    it 'receives an unauthorized response', vcr: vcr_options do
      expect(retrieve_tss).to match(status: :error, message: 'Unauthorized', body: a_kind_of(Hash))
    end
  end
end
