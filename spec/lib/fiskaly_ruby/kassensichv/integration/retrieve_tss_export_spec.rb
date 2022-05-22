RSpec.describe 'Retrieve TSS export' do
  subject(:retrieve_tss_export) do
    FiskalyRuby::KassenSichV::TSS::Export::Retrieve.new(token: token, tss_id: tss_id, export_id: export_id).call
  end

  let(:token) { FiskalyTesting.kassensichv_authenticate }
  let(:tss) { FiskalyTesting.kassensichv_find_or_create_tss(token: token) }
  let(:tss_id) { tss.tss_id }

  context 'with valid data' do
    include_context 'setup Fiskaly env'

    let(:export_id) { ENV['RSPEC_FISKALY_TSS_EXPORT_ID'] }

    before { tss }

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_export_retrieve_ok' }
    it 'retrieves the tss export', vcr: vcr_options do
      expect(retrieve_tss_export).to match(status: :ok, body: a_kind_of(Hash))
    end
  end

  context 'with invalid data' do
    include_context 'setup Fiskaly env'

    let(:export_id) { '00000000-0000-0000-0000-0000000' }

    before do
      ENV['RSPEC_FISKALY_TSS_EXPORT_ID'] = export_id
      tss
    end

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_export_retrieve_error' }
    it 'receives a bad request response', vcr: vcr_options do
      expect(retrieve_tss_export).to match(status: :error, message: 'Bad Request', body: a_kind_of(Hash))
    end
  end
end
