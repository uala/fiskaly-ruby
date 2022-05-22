RSpec.describe 'Create TSS client' do
  subject(:create_tss_client) do
    FiskalyRuby::KassenSichV::TSS::Client::Create.new(
      token: token,
      tss_id: tss_id,
      client_id: client_id,
      payload: { serial_number: serial_number }
    ).call
  end

  let(:token) { FiskalyTesting.kassensichv_authenticate }
  let(:tss) { FiskalyTesting.kassensichv_find_or_create_tss(token: token) }
  let(:client_id) { ENV.fetch('RSPEC_FISKALY_TSS_CLIENT_ID', '22bb2b22-b2b2-22b2-2bb2-2bbb2b2bbb22') }
  let(:serial_number) { ENV.fetch('RSPEC_FISKALY_TSS_CLIENT_SERIAL_NUMBER', 'someserialnumber') }

  context 'with valid data' do
    include_context 'setup Fiskaly env'

    let(:tss_id) { tss.tss_id }

    before do
      FiskalyTesting.kassensichv_admin_setup(token: token, tss_id: tss_id, admin_puk: tss.admin_puk)
    end

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_client_create_ok' }
    it 'should create a client', vcr: vcr_options do
      expect(create_tss_client).to match(status: :ok, body: a_kind_of(Hash))
    end
  end

  context 'with invalid data' do
    include_context 'setup Fiskaly env'

    let(:tss_id) { '22bb2b22-0000-0000-0000-2bbb2b2bbb22' }

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_client_create_error' }
    it 'should not create a client', vcr: vcr_options do
      expect(create_tss_client).to match(status: :error, message: 'Not Found', body: a_kind_of(Hash))
    end
  end
end
