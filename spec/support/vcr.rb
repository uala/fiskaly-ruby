VCR.configure do |config|
  config.cassette_library_dir = File.expand_path(File.join(File.dirname(__FILE__), 'spec', 'vcr'))
  config.hook_into :webmock

  config.allow_http_connections_when_no_cassette = false
  # config.ignore_localhost = true

  # config.before_record { |i| i.response.body.force_encoding('UTF-8') }

  config.default_cassette_options = {
    record: ENV.fetch('RSPEC_VCR_RECORD_MODE', 'once').to_sym,
    erb: true
  }

  # Configures RSpec to use a VCR cassette for any example tagged with `:vcr`.
  # see https://relishapp.com/vcr/vcr/v/2-9-3/docs/test-frameworks/usage-with-rspec-metadata
  config.configure_rspec_metadata!

  ### Filter sensitive data rules
  # see https://relishapp.com/vcr/vcr/docs/configuration/filter-sensitive-data

  config.filter_sensitive_data('{"BINARY DATA": true}', :fiskaly_service) do |interaction|
    # Replace binary body data to permit JSON parsing in the rules below
    interaction.response.body if interaction.response.body.encoding.name == 'ASCII-8BIT'
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_API_KEY>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_API_KEY', 'some_fiskaly_api_key')
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_API_SECRET>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_API_SECRET', 'some_fiskaly_api_secret')
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_INVALID_API_KEY>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_INVALID_API_KEY', 'some_invalid_fiskaly_api_key')
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_INVALID_API_SECRET>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_INVALID_API_SECRET', 'some_invalid_fiskaly_api_secret')
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_ORGANIZATION_ID>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_ORGANIZATION_ID', 'some_fiskaly_organization_id')
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_INVALID_ORGANIZATION_ID>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_ORGANIZATION_ID', 'a2aa222a-2222-22a2-2222-a22a2aa222a2')
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_MANAGED_BY_ORGANIZATION_ID>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_MANAGED_BY_ORGANIZATION_ID', 'some_fiskaly_managed_by_organization_id')
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_INVALID_MANAGED_BY_ORGANIZATION_ID>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_INVALID_MANAGED_BY_ORGANIZATION_ID', 'a1aa111a-1111-11a1-1111-a11a1aa111a1')
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_TSS_CLIENT_SERIAL_NUMBER>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_TSS_CLIENT_SERIAL_NUMBER', 'someserialnumber')
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_INVALID_TSS_ID>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_INVALID_TSS_ID', 'someinvalidtssid')
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_TSS_CLIENT_ID>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_TSS_CLIENT_ID', '22bb2b22-b2b2-22b2-2bb2-2bbb2b2bbb22')
  end
  config.filter_sensitive_data('<RSPEC_FISKALY_TX_ID>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_TX_ID', '33bb3b33-b3b3-33b3-3bb3-3bbb3b3bbb33')
  end
  config.filter_sensitive_data('some_client_id', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_CLIENT_ID', 'some_client_id')
  end

  config.filter_sensitive_data('some_tss_id', :fiskaly_service) do # used also in some URLs
    ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id')
  end
  config.filter_sensitive_data('some_tss_export_id', :fiskaly_service) do # used also in some URLs
    ENV.fetch('RSPEC_FISKALY_TSS_EXPORT_ID', 'some_tss_export_id')
  end
  config.filter_sensitive_data('some_dsfinvk_export_id', :fiskaly_service) do # used also in some URLs
    ENV.fetch('RSPEC_FISKALY_DSFINVK_EXPORT_ID', 'some_dsfinvk_export_id')
  end

  config.filter_sensitive_data('<Access Token>', :fiskaly_service) do |interaction|
    JSON.parse(interaction.response.body)['access_token']
  end
  config.filter_sensitive_data('<Refresh Token>', :fiskaly_service) do |interaction|
    JSON.parse(interaction.response.body)['refresh_token']
  end
  config.filter_sensitive_data('<Organization ID>', :fiskaly_service) do |interaction|
    JSON.parse(interaction.response.body).dig('access_token_claims', 'organization_id')
  end
  config.filter_sensitive_data('<Api Key>', :fiskaly_service) do |interaction|
    JSON.parse(interaction.response.body)['key']
  end
  config.filter_sensitive_data('<Api Secret>', :fiskaly_service) do |interaction|
    JSON.parse(interaction.response.body)['secret']
  end
  config.filter_sensitive_data('<Certificate>', :fiskaly_service) do |interaction|
    JSON.parse(interaction.response.body)['certificate']
  end
  config.filter_sensitive_data('<Tss admin pin>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_TSS_ADMIN_PIN', 'some-admin-pin')
  end
  config.filter_sensitive_data('<Tss admin puk>', :fiskaly_service) do
    ENV.fetch('RSPEC_FISKALY_TSS_ADMIN_PUK', 'some-admin-puk')
  end
end

RSpec.configure do |config|
  config.around(:each, :allow_http_requests) do |example|
    VCR.configuration.allow_http_connections_when_no_cassette = true
    example.run
    VCR.configuration.allow_http_connections_when_no_cassette = false
  end
end
