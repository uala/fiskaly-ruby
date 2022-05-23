# frozen_string_literal: true

RSpec.describe FiskalyRuby::Management::Organizations::Create do
  let(:api_key) { ENV.fetch('RSPEC_FISKALY_API_KEY', 'some_fiskaly_api_key') }
  let(:api_secret) { ENV.fetch('RSPEC_FISKALY_API_SECRET', 'some_fiskaly_api_secret') }
  let(:managed_by_organization_id) do
    ENV.fetch('RSPEC_FISKALY_MANAGED_BY_ORGANIZATION_ID', 'some_fiskaly_managed_by_organization_id')
  end

  describe 'NAME_REGEXP' do
    let(:char) { 'x' }

    context 'with a valid name' do
      it 'matches the regexp' do
        expect(described_class::NAME_REGEXP.match?(char * 3)).to be_truthy
        expect(described_class::NAME_REGEXP.match?(char.upcase * 3)).to be_truthy
      end
    end

    context 'with an invalid name' do
      it "doesn't match the regexp" do
        expect(described_class::NAME_REGEXP.match?(char * 1)).to be_falsey
      end
    end
  end

  describe '#body' do
    let(:payload) do
      {
        name: 'somename',
        address_line1: 'some_address_line1',
        zip: 'some_zip',
        town: 'some_town',
        country_code: 'some_country_code',
        managed_by_organization_id: managed_by_organization_id,
        display_name: 'some_display_name',
        vat_id: 'some_vat_id',
        contact_person_id: 'some_contact_person_id',
        address_line2: 'some_address_line2',
        state: 'some_state',
        tax_number: 'some_tax_number',
        economy_id: 'some_economy_id',
        billing_options: 'some_billing_options',
        billing_address_id: 'some_billing_address_id',
        metadata: 'some_metadata'
      }
    end

    let(:organization) do
      described_class.new(token: 'some_token', payload: payload)
    end

    it 'returns the request body' do
      expect(organization.body).to be_json_eql({
        name: organization.payload[:name],
        address_line1: organization.payload[:address_line1],
        zip: organization.payload[:zip],
        town: organization.payload[:town],
        country_code: organization.payload[:country_code],
        managed_by_organization_id: organization.payload[:managed_by_organization_id],
        display_name: organization.payload[:display_name],
        vat_id: organization.payload[:vat_id],
        contact_person_id: organization.payload[:contact_person_id],
        address_line2: organization.payload[:address_line2],
        state: organization.payload[:state],
        tax_number: organization.payload[:tax_number],
        economy_id: organization.payload[:economy_id],
        billing_options: organization.payload[:billing_options],
        billing_address_id: organization.payload[:billing_address_id],
        metadata: organization.payload[:metadata]
      }.to_json)
    end
  end

  describe '#call' do
    context 'with invalid name parameter' do
      let(:payload) do
        {
          name: 'x',
          address_line1: 'some_address_line1',
          zip: 'some_zip',
          town: 'some_town',
          country_code: 'ITA',
          managed_by_organization_id: managed_by_organization_id,
          display_name: 'some_display_name',
          vat_id: 'some_vat_id',
          contact_person_id: 'some_contact_person_id',
          address_line2: 'some_address_line2',
          state: 'some_state',
          tax_number: 'some_tax_number',
          economy_id: 'some_economy_id',
          billing_options: 'some_billing_options',
          billing_address_id: 'some_billing_address_id',
          metadata: 'some_metadata'
        }
      end

      let(:organization) do
        described_class.new(token: 'some_token', payload: payload)
      end

      let(:error_message) { "Invalid name for: #{organization.payload[:name].inspect}, please use a lowercase >= 3 characters string" }

      it 'raises a RuntimeError exception' do
        expect { organization.call }.to raise_error(RuntimeError, error_message)
      end
    end

    context 'with invalid country_code parameter' do
      let(:payload) do
        {
          name: 'somename',
          address_line1: 'some_address_line1',
          zip: 'some_zip',
          town: 'some_town',
          country_code: 'some_invalid_country_code',
          managed_by_organization_id: managed_by_organization_id,
          display_name: 'some_display_name',
          vat_id: 'some_vat_id',
          contact_person_id: 'some_contact_person_id',
          address_line2: 'some_address_line2',
          state: 'some_state',
          tax_number: 'some_tax_number',
          economy_id: 'some_economy_id',
          billing_options: 'some_billing_options',
          billing_address_id: 'some_billing_address_id',
          metadata: 'some_metadata'
        }
      end
      let(:organization) do
        described_class.new(token: 'some_token', payload: payload)
      end

      let(:error_message) { "Invalid country_code for: #{organization.payload[:country_code].inspect}, please use one of these: #{described_class::COUNTRY_CODES}" }

      it 'raises a RuntimeError exception' do
        expect { organization.call }.to raise_error(RuntimeError, error_message)
      end
    end

    context 'with invalid metadata parameter' do
      let(:payload) do
        {
          name: 'somename',
          address_line1: 'some_address_line1',
          zip: 'some_zip',
          town: 'some_town',
          country_code: 'ITA',
          managed_by_organization_id: managed_by_organization_id,
          display_name: 'some_display_name',
          vat_id: 'some_vat_id',
          contact_person_id: 'some_contact_person_id',
          address_line2: 'some_address_line2',
          state: 'some_state',
          tax_number: 'some_tax_number',
          economy_id: 'some_economy_id',
          billing_options: 'some_billing_options',
          billing_address_id: 'some_billing_address_id',
          metadata: 'some_invalid_metadata'
        }
      end
      let(:organization) do
        described_class.new(token: 'some_token', payload: payload)
      end

      let(:error_message) do
        <<~ERROR_MESSAGE
          Invalid 'metadata' type: #{organization.payload[:metadata].class.inspect}, please use a Hash.
          You can use this parameter to attach custom key-value data to an object.
          Metadata is useful for storing additional, structured information on an object.
          Note: You can specify up to 20 keys,
          with key names up to 40 characters long and values up to 500 characters long.
        ERROR_MESSAGE
      end

      it 'raises a RuntimeError exception' do
        expect { organization.call }.to raise_error(RuntimeError, error_message)
      end
    end

    context 'with valid data' do
      let(:payload) do
        {
          name: 'somename',
          address_line1: 'some_address_line1',
          zip: 'some_zip',
          town: 'some_town',
          country_code: 'ITA',
          managed_by_organization_id: managed_by_organization_id
        }
      end

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/management/organizations_create_ok' }
      it 'creates an organization', vcr: vcr_options do
        authenticate_context = FiskalyRuby::Management::Authenticate.call(api_key: api_key, api_secret: api_secret)
        access_token = authenticate_context[:body]['access_token']
        create_organization = described_class.new(token: access_token, payload: payload)

        expect(create_organization.call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end

    context 'with invalid data' do
      let(:invalid_managed_by_organization_id) do
        # NOTE: fake organization UUID
        ENV.fetch('RSPEC_FISKALY_INVALID_MANAGED_BY_ORGANIZATION_ID', 'a1aa111a-1111-11a1-1111-a11a1aa111a1')
      end
      let(:payload) do
        {
          name: 'somename',
          address_line1: 'some_address_line1',
          zip: 'some_zip',
          town: 'some_town',
          country_code: 'ITA',
          managed_by_organization_id: invalid_managed_by_organization_id
        }
      end

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/management/organizations_create_error' }
      it "doesn't create an organization", vcr: vcr_options do
        authenticate_context = FiskalyRuby::Management::Authenticate.call(api_key: api_key, api_secret: api_secret)
        access_token = authenticate_context[:body]['access_token']
        create_organization = described_class.new(token: access_token, payload: payload)

        expect(create_organization.call).to match(status: :error, message: 'Not Found', body: a_kind_of(Hash))
      end
    end
  end
end
