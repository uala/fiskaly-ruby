# frozen_string_literal: true

RSpec.describe FiskalyRuby::KassenSichV::TSS::Client::Create do
  it 'inherits from "FiskalyRuby::KassenSichV::Base" class' do
    expect(described_class).to be < FiskalyRuby::KassenSichV::Base
  end

  describe '#required_payload_attributes' do
    it 'returns "required_payload_attributes" array' do
      update_tss = described_class.new(token: 'some_token', tss_id: 'some_tss')

      expect(update_tss.required_payload_attributes).to eq(%i(serial_number))
    end
  end

  describe '#optional_payload_attributes' do
    it 'returns "optional_payload_attributes" array' do
      update_tss = described_class.new(token: 'some_token', tss_id: 'some_tss')

      expect(update_tss.optional_payload_attributes).to eq(%i(metadata))
    end
  end

  describe '#call' do
    context 'with valid data' do
      include_context 'with a stubbed request', method: :put

      subject(:call) do
        described_class.new(token: 'some token', tss_id: tss_id, client_id: client_id, payload: payload).call
      end

      let(:tss_id) { ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id') }
      let(:client_id) { ENV.fetch('RSPEC_FISKALY_TSS_CLIENT_ID', '22bb2b22-b2b2-22b2-2bb2-2bbb2b2bbb22') }
      let(:serial_number) { ENV.fetch('RSPEC_FISKALY_TSS_CLIENT_SERIAL_NUMBER', 'someserialnumber') }
      let(:payload) { { serial_number: serial_number } }

      before { call }

      it 'makes a PUT request and receives a successful response', :aggregate_failures do
        expect(described_class).to have_received(:put)
        expect(call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end
  end
end
