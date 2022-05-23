# frozen_string_literal: true

RSpec.describe FiskalyRuby::KassenSichV::TSS::Update do
  it 'inherits from "FiskalyRuby::KassenSichV::Base" class' do
    expect(described_class).to be < FiskalyRuby::KassenSichV::Base
  end

  describe 'STATES' do
    it 'returns states array' do
      expect(described_class::STATES).to eq(%i(UNINITIALIZED INITIALIZED DISABLED))
    end
  end

  describe '#required_payload_attributes' do
    it 'returns "required_payload_attributes" array' do
      update_tss = described_class.new(token: 'some_token', tss_id: 'some_tss')

      expect(update_tss.required_payload_attributes).to eq(%i(state))
    end
  end

  describe '#optional_payload_attributes' do
    it 'returns "optional_payload_attributes" array' do
      update_tss = described_class.new(token: 'some_token', tss_id: 'some_tss')

      expect(update_tss.optional_payload_attributes).to eq(%i(description metadata))
    end
  end

  describe '#call' do
    let(:tss_id) { ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id') }

    context 'with valid data' do
      include_context 'with a stubbed request', method: :patch

      subject(:call) { described_class.new(token: 'some_token', tss_id: tss_id, payload: payload).call }

      let(:payload) { { state: :UNINITIALIZED } }

      before { call }

      it 'makes a PATCH request and receives a successful response', :aggregate_failures do
        expect(described_class).to have_received(:patch)
        expect(call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end

    context 'with invalid data' do
      context 'with an invalid "state" parameter' do
        let(:invalid_state) { 'some_invalid_state' }
        let(:error_message) { "Invalid state for: #{invalid_state.inspect}" }

        it 'raises a RuntimeError exception' do
          create_tss = described_class.new(token: 'some_token', tss_id: tss_id, payload: { state: invalid_state })

          expect { create_tss.call }.to raise_error(RuntimeError, error_message)
        end
      end

      context 'with an invalid "metadata" parameter' do
        let(:invalid_metadata) { 'some_invalid_metadata' }
        let(:error_message) do
          <<~ERROR_MESSAGE
            Invalid 'metadata' type: #{invalid_metadata.class.inspect}, please use a Hash.
            You can use this parameter to attach custom key-value data to an object.
            Metadata is useful for storing additional, structured information on an object.
            Note: You can specify up to 20 keys,
            with key names up to 40 characters long and values up to 500 characters long.
          ERROR_MESSAGE
        end
        let(:payload) { { state: :UNINITIALIZED, metadata: invalid_metadata } }

        it 'raises a RuntimeError exception' do
          update_tss = described_class.new(token: 'some_token', tss_id: tss_id, payload: payload)

          expect { update_tss.call }.to raise_error(RuntimeError, error_message)
        end
      end
    end
  end
end
