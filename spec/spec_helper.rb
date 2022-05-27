# frozen_string_literal: true

unless ENV['DISABLE_SIMPLE_COV']
  require 'simplecov'

  SimpleCov.start do
    add_filter '/spec/'
    minimum_coverage 98
    maximum_coverage_drop 1
  end
end

require 'fiskaly-ruby'
require 'fiskaly_testing'
require 'rubygems'
require 'vcr'
require 'pry'
require 'json_spec'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false

  config.default_cassette_options = {
    record: :once,
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

  config.include JsonSpec::Helpers

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

RSpec.shared_context 'with a stubbed request' do |options|
  let(:response) { instance_double(HTTParty::Response, success?: success, response: http_response) }
  let(:success) { options.key?(:success) ? options[:success] : true }
  let(:http_response) { instance_double(Net::HTTPResponse, body: http_response_body.to_json) }
  let(:http_response_body) { options[:response_body] || {} }

  before do
    request_class = options[:request_class] || described_class
    allow(request_class).to receive(options[:method]).and_return(response)
  end
end
