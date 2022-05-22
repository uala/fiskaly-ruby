RSpec.describe 'Retrieve TSS export file' do
  subject(:retrieve_tss_export_file) do
    FiskalyRuby::KassenSichV::TSS::Export::RetrieveFile.new(token: token, tss_id: tss_id, export_id: export_id).call
  end

  let(:token) { FiskalyTesting.kassensichv_authenticate }
  let(:tss) { FiskalyTesting.kassensichv_find_or_create_tss(token: token) }
  let(:tss_id) { tss.tss_id }

  context 'with valid data' do
    include_context 'setup Fiskaly env'

    let(:export_id) { ENV['RSPEC_FISKALY_TSS_EXPORT_ID'] }

    before { tss }

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_export_file_ok' }
    it 'retrieves an export file', :aggregate_failures, vcr: vcr_options do
      expect(retrieve_tss_export_file).to include(status: :ok)

      parsed_body = JSON.parse(retrieve_tss_export_file[:body])
      expect(parsed_body).to eq('BINARY DATA' => true)
    end
  end

  context 'with invalid data' do
    include_context 'setup Fiskaly env'

    let(:export_id) { '00000000-0000-0000-0000-0000000' }

    before do
      ENV['RSPEC_FISKALY_TSS_EXPORT_ID'] = export_id
      tss
    end

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_export_file_error' }
    it 'returns a schema validation error', vcr: vcr_options do
      error = 'Bad Request'
      attrs = { 'code' => 'E_FAILED_SCHEMA_VALIDATION', 'error' => error, 'status_code' => 400 }

      expect(retrieve_tss_export_file).to match(status: :error, message: error, body: a_hash_including(attrs))
    end
  end
end
