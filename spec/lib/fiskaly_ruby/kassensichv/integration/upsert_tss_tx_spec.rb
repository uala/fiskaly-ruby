# frozen_string_literal: true

RSpec.describe 'Upsert TSS transaction' do
  subject(:upsert_tss_tx) do
    FiskalyRuby::KassenSichV::TSS::Tx::Upsert.new(
      token: token,
      tss_id: tss_id,
      tx_id_or_number: tx_id_or_number,
      payload: payload
    ).call
  end

  let(:token) { FiskalyTesting.kassensichv_authenticate }
  let(:tss) { FiskalyTesting.kassensichv_find_or_create_tss(token: token) }
  let(:tx_id_or_number) { ENV.fetch('RSPEC_FISKALY_TX_ID', '33bb3b33-b3b3-33b3-3bb3-3bbb3b3bbb33') }
  let(:client_id) { ENV.fetch('RSPEC_FISKALY_TSS_CLIENT_ID', '22bb2b22-b2b2-22b2-2bb2-2bbb2b2bbb22') }

  context 'with valid data' do
    include_context 'setup Fiskaly env'

    let(:tss_id) { tss.tss_id }
    let(:payload) do
      {
        state: :ACTIVE,
        client_id: client_id
      }
    end

    before do
      FiskalyTesting.kassensichv_admin_setup(token: token, tss_id: tss_id, admin_puk: tss.admin_puk)
      FiskalyTesting.kassensichv_create_client(token: token, tss_id: tss_id, client_id: client_id)
    end

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_tx_upsert_ok' }
    it 'upsert a tx', vcr: vcr_options do
      expect(upsert_tss_tx).to match(status: :ok, body: a_kind_of(Hash))
    end
  end
end
