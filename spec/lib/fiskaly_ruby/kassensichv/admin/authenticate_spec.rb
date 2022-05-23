# frozen_string_literal: true

RSpec.describe FiskalyRuby::KassenSichV::Admin::Authenticate do
  describe 'ADMIN_PIN_REGEXP' do
    let(:char) { 'x' }

    context 'valid admin_pin' do
      it 'should match the regexp' do
        expect(described_class::ADMIN_PIN_REGEXP.match?(char * 6)).to be_truthy
        expect(described_class::ADMIN_PIN_REGEXP.match?(char.upcase * 6)).to be_truthy
      end
    end

    context 'invalid admin_pin' do
      it 'should not match the regexp' do
        expect(described_class::ADMIN_PIN_REGEXP.match?(char * 1)).to be_falsey
      end
    end
  end

  describe '#call' do
    context 'with valid parameters' do
      let(:authenticate) do
        described_class.new(
          token: ENV.fetch('RSPEC_FISKALY_BEARER_TOKEN', 'some_bearer_token'),
          tss_id: ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id'),
          payload: { admin_pin: ENV.fetch('RSPEC_FISKALY_TSS_ADMIN_PIN', '123456') }
        )
      end

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/admin_authenticate_ok' }
      it 'should authenticate admin', vcr: vcr_options do
        expect(authenticate.call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end

    context 'with fiskaly errors' do
      let(:authenticate) do
        described_class.new(
          token: ENV.fetch('RSPEC_FISKALY_BEARER_TOKEN', 'some_bearer_token'),
          tss_id: 'some_tss_id',
          payload: { admin_pin: ENV.fetch('RSPEC_FISKALY_TSS_ADMIN_PIN', '123456') }
        )
      end

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/admin_authenticate_error' }
      it 'should not authenticate admin', vcr: vcr_options do
        expect(authenticate.call).to match(status: :error, message: 'Bad Request', body: a_kind_of(Hash))
      end
    end

    context 'with invalid parameters' do
      let(:authenticate) do
        described_class.new(
          token: 'some_token',
          tss_id: 'some_tss_id',
          payload: { admin_pin: 'x' }
        )
      end

      it 'should raise error' do
        expect { authenticate.call }.to raise_error(RuntimeError, "Invalid admin_pin for: #{authenticate.payload[:admin_pin].inspect}")
      end
    end
  end

  describe '#body' do
    let(:authenticate) do
      described_class.new(
        token: 'some_token',
        tss_id: 'some_tss_id',
        payload: { admin_pin: '123456' }
      )
    end

    it 'should return the body' do
      expect(authenticate.body).to be_json_eql({
        admin_pin: authenticate.payload[:admin_pin]
      }.to_json)
    end
  end
end
