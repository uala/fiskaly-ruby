# frozen_string_literal: true

RSpec.describe FiskalyRuby::KassenSichV::TSS::Export::Trigger do
  it 'inherits from "FiskalyRuby::KassenSichV::Base" class' do
    expect(described_class).to be < FiskalyRuby::KassenSichV::Base
  end

  describe '#optional_payload_attributes' do
    it 'returns "optional_payload_attributes" array' do
      required_attributes = %i(client_id transaction_number start_transaction_number end_transaction_number start_date
                               end_date maximum_number_records start_signature_counter end_signature_counter)

      upsert_tx = described_class.new(token: 'some_token', tss_id: 'some_tss_id')

      expect(upsert_tx.optional_payload_attributes).to eq(required_attributes)
    end
  end

  describe '#call' do
    context 'with valid data' do
      include_context 'with a stubbed request', method: :put

      subject(:call) { described_class.new(token: 'some_token', tss_id: tss_id, export_id: export_id).call }

      let(:tss_id) { ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id') }
      let(:export_id) { ENV.fetch('RSPEC_FISKALY_TSS_EXPORT_ID', '44bb4b44-b4b4-44b4-4bb4-4bbb4b4bbb44') }

      before { call }

      it 'makes a PUT request and receives a successful response', :aggregate_failures do
        expect(described_class).to have_received(:put)
        expect(call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end

    context 'with invalid data' do
      context 'with invalid "client_id"' do
        let(:client_id) { 11_111 }
        let(:payload_with_invalid_client_id) { { client_id: client_id } }
        let(:error_message) { "Invalid client_id for: #{client_id.inspect}, please use a string" }
        let(:trigger_export) do
          described_class.new(
            token: 'some_token',
            tss_id: 'some_tss_id',
            export_id: 'some_export_id',
            payload: payload_with_invalid_client_id
          )
        end

        it 'should raise error' do
          expect { trigger_export.call }.to raise_error(RuntimeError, error_message)
        end
      end

      context 'with invalid digits attributes' do
        it 'should raise error' do
          attributes = %i(transaction_number start_transaction_number end_transaction_number maximum_number_records
                          start_signature_counter end_signature_counter)
          attributes.each do |attr|
            error_message = "Invalid attribute for: #{attr}, please use a digit string"
            trigger_export = described_class.new(
              token: 'some_token',
              tss_id: 'some_tss_id',
              export_id: 'some_export_id',
              payload: {
                attr => 'aaaaa'
              }
            )
            expect { trigger_export.call }.to raise_error(RuntimeError, error_message)
          end
        end
      end

      context 'with invalid integer attributes' do
        it 'should raise error' do
          attributes = %i(start_date end_date)
          attributes.each do |attr|
            error_message = "Invalid attribute for: #{attr}, please use an integer"
            trigger_export = described_class.new(
              token: 'some_token',
              tss_id: 'some_tss_id',
              export_id: 'some_export_id',
              payload: {
                attr => 'aaaaa'
              }
            )
            expect { trigger_export.call }.to raise_error(RuntimeError, error_message)
          end
        end
      end
    end
  end
end
