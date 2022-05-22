RSpec.shared_context 'setup Fiskaly env' do
  before do
    tss_id_file = File.open(File.expand_path('tmp/test_fiskaly_tss_export_id', __dir__)) rescue nil
    if tss_id_file.present?
      # Needed for VCR filters
      ENV['RSPEC_FISKALY_TSS_ID'] ||= File.read(tss_id_file)
      ENV['RSPEC_FISKALY_TSS_ADMIN_PUK'] ||= Rails.root.join('tmp/test_fiskaly_tss_admin_puk').read rescue nil
      ENV['RSPEC_FISKALY_TSS_EXPORT_ID'] ||= Rails.root.join('tmp/test_fiskaly_tss_export_id').read rescue nil
    else
      ENV['RSPEC_FISKALY_TSS_ID'] ||= 'some_tss_id'
      ENV['RSPEC_FISKALY_TSS_ADMIN_PUK'] ||= 'some-admin-puk'
      ENV['RSPEC_FISKALY_TSS_EXPORT_ID'] ||= 'some_tss_export_id'
    end
  end
end

module FiskalyTesting
  TssData = Struct.new(:tss_id, :admin_puk)

  module_function

  def kassensichv_authenticate(override_params: {})
    params = {
      api_key: ENV.fetch('RSPEC_FISKALY_API_KEY', 'some_fiskaly_api_key'),
      api_secret: ENV.fetch('RSPEC_FISKALY_API_SECRET', 'some_fiskaly_api_secret')
    }.merge(override_params)
    result = FiskalyRuby::KassenSichV::Authenticate.call(params)
    result.dig(:body, 'access_token')
  end

  def kassensichv_find_or_create_tss(token:)
    # require 'setup Fiskaly env' shared context to work properly
    tss_id = ENV['RSPEC_FISKALY_TSS_ID']
    admin_puk = ENV['RSPEC_FISKALY_TSS_ADMIN_PUK']
    unless tss_id
      tss_id = SecureRandom.uuid
      result = FiskalyRuby::KassenSichV::TSS::Create.call(token: token, tss_id: tss_id)
      FiskalyRuby::KassenSichV::TSS::Update.call(token: token, tss_id: tss_id, payload: { state: :UNINITIALIZED })
      admin_puk = result.dig(:body, 'admin_puk')
      Rails.root.join('tmp/test_fiskaly_tss_id').write(tss_id)
      Rails.root.join('tmp/test_fiskaly_tss_admin_puk').write(admin_puk)
    end

    TssData.new(tss_id, admin_puk)
  end

  def kassensichv_admin_setup(token:, tss_id:, admin_puk:)
    payload = { admin_puk: admin_puk, new_admin_pin: ENV.fetch('RSPEC_FISKALY_TSS_ADMIN_PIN', '123456') }
    FiskalyRuby::KassenSichV::TSS::ChangeAdminPin.call(token: token, tss_id: tss_id, payload: payload)
    payload = { admin_pin: ENV.fetch('RSPEC_FISKALY_TSS_ADMIN_PIN', '123456') }
    FiskalyRuby::KassenSichV::Admin::Authenticate.call(token: token, tss_id: tss_id, payload: payload)
  end

  def kassensichv_tss_update(token:, tss_id:)
    FiskalyRuby::KassenSichV::TSS::Update.call(token: token, tss_id: tss_id, payload: { state: :INITIALIZED })
  end

  def kassensichv_create_client(token:, tss_id:, client_id:)
    kassensichv_tss_update(token: token, tss_id: tss_id)
    FiskalyRuby::KassenSichV::TSS::Client::Create.call(
      token: token,
      tss_id: tss_id,
      client_id: client_id,
      payload: {
        serial_number: '12345'
      }
    )
  end

  def kassensichv_store_tss_export_reference(export_id:)
    # TODO: CHECK if this is needed -> Rails.root.join('tmp/test_fiskaly_tss_export_id').write(export_id)
  end
end
