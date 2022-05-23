# frozen_string_literal: true

RSpec.describe FiskalyRuby::KassenSichV::TSS::Tx::Upsert do
  it 'inherits from "FiskalyRuby::KassenSichV::Base" class' do
    expect(described_class).to be < FiskalyRuby::KassenSichV::Base
  end

  describe 'STATES' do
    it 'returns states array' do
      expect(described_class::STATES).to eq(%i(ACTIVE CANCELLED FINISHED))
    end
  end

  describe '#required_payload_attributes' do
    it 'returns "required_payload_attributes" array' do
      upsert_tx = described_class.new(token: 'some_token', tss_id: 'some_tss')

      expect(upsert_tx.required_payload_attributes).to eq(%i(state client_id))
    end
  end

  describe '#optional_payload_attributes' do
    it 'returns "optional_payload_attributes" array' do
      upsert_tx = described_class.new(token: 'some_token', tss_id: 'some_tss_id')

      expect(upsert_tx.optional_payload_attributes).to eq(%i(schema metadata))
    end
  end

  describe '#call' do
    let(:tss_id) { ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id') }
    let(:client_id) { ENV.fetch('RSPEC_FISKALY_TSS_CLIENT_ID', '22bb2b22-b2b2-22b2-2bb2-2bbb2b2bbb22') }

    context 'with valid data' do
      include_context 'with a stubbed request', method: :put

      subject(:call) do
        described_class.new(
          token: 'some_token',
          tss_id: tss_id,
          tx_id_or_number: tx_id_or_number,
          payload: payload
        ).call
      end

      let(:tx_id_or_number) { ENV.fetch('RSPEC_FISKALY_TX_ID', '33bb3b33-b3b3-33b3-3bb3-3bbb3b3bbb33') }
      let(:payload) { { state: :ACTIVE, client_id: client_id } }

      before { call }

      it 'makes a PUT request and receives a successful response', :aggregate_failures do
        expect(described_class).to have_received(:put)
        expect(call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end

    context 'with invalid data' do
      let(:client_id) { 'some_client_id' }
      let(:upsert_tx) { described_class.new(token: 'some_token', tss_id: tss_id, payload: payload) }

      context 'with an invalid "state" parameter' do
        let(:invalid_state) { 'some_invalid_state' }
        let(:error_message) { "Invalid state for: #{invalid_state.inspect}" }
        let(:payload) { { state: invalid_state, client_id: client_id } }

        it 'raises a RuntimeError exception' do
          expect { upsert_tx.call }.to raise_error(RuntimeError, error_message)
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
        let(:payload) { { state: :ACTIVE, client_id: client_id, metadata: invalid_metadata } }

        it 'raises a RuntimeError exception' do
          expect { upsert_tx.call }.to raise_error(RuntimeError, error_message)
        end
      end

      context 'with tx_revision > 1 && payload[:schema].nil? && payload[:state] != :FINISHED' do
        let(:error_message) do
          <<~ERROR_MESSAGE
            Missing payload 'schema' attribute.
            When 'tx_revision' is greater then 1 and 'state' is different from :FINISHED
            then payload 'schema' attribute must be filled with this structure:
            {
              schema: {
                receipt: {
                  receipt_type:,
                  amounts_per_vat_rate: [
                    {
                      vat_rate:,
                      amount:
                    }
                  ],
                  amounts_per_payment_type: [
                    {
                      payment_type:,
                      amount:,
                      currency_code:
                    }
                  ]
                }
              }
            }
          ERROR_MESSAGE
        end
        let(:payload) { { state: :ACTIVE, client_id: client_id, schema: nil } }
        let(:upsert_tx) do
          described_class.new(token: 'some_token', tss_id: tss_id, payload: payload, tx_revision: 2)
        end

        it 'raises a RuntimeError exception' do
          expect { upsert_tx.call }.to raise_error(RuntimeError, error_message)
        end
      end
    end
  end
end
