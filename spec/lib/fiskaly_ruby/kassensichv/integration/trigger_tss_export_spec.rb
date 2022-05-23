# frozen_string_literal: true

RSpec.describe 'Trigger TSS export' do
  subject(:trigger_tss_export) do
    FiskalyRuby::KassenSichV::TSS::Export::Trigger.new(token: token, tss_id: tss_id, export_id: export_id).call
  end

  let(:token) { FiskalyTesting.kassensichv_authenticate }
  let(:tss) { FiskalyTesting.kassensichv_find_or_create_tss(token: token) }
  let(:export_id) { SecureRandom.uuid }

  context 'with valid data' do
    include_context 'setup Fiskaly env'

    let(:tss_id) { tss.tss_id }

    before do
      ENV['RSPEC_FISKALY_TSS_EXPORT_ID'] = export_id
      FiskalyTesting.kassensichv_admin_setup(token: token, tss_id: tss_id, admin_puk: tss.admin_puk)
      FiskalyTesting.kassensichv_tss_update(token: token, tss_id: tss_id)
    end

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_trigger_export_ok' }
    it 'trigger an export', vcr: vcr_options do
      expect(trigger_tss_export).to match(status: :ok, body: a_kind_of(Hash))
    end
  end
end
