# frozen_string_literal: true

RSpec.describe 'Change TSS admin PIN' do
  subject(:change_admin_pin) do
    FiskalyRuby::KassenSichV::TSS::ChangeAdminPin.new(token: token, tss_id: tss.tss_id, payload: payload).call
  end

  let(:token) { FiskalyTesting.kassensichv_authenticate }
  let(:tss) { FiskalyTesting.kassensichv_find_or_create_tss(token: token) }

  context 'with valid data' do
    include_context 'setup Fiskaly env'

    let(:payload) do
      {
        admin_puk: tss.admin_puk,
        new_admin_pin: ENV.fetch('RSPEC_FISKALY_TSS_ADMIN_PIN', '123456')
      }
    end

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_change_admin_pin_ok' }
    it 'should change admin pin admin', vcr: vcr_options do
      expect(change_admin_pin).to match(status: :ok, body: a_kind_of(Hash))
    end
  end

  context 'with invalid data' do
    include_context 'setup Fiskaly env'

    let(:payload) do
      {
        admin_puk: 'some-invalid-puk',
        new_admin_pin: 'some-admin-pin'
      }
    end

    vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/tss_change_admin_pin_error' }
    it 'should not change admin pin', vcr: vcr_options do
      expect(change_admin_pin).to match(status: :error, message: 'Unauthorized', body: a_kind_of(Hash))
    end
  end
end
