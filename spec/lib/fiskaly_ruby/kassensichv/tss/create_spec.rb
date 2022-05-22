RSpec.describe FiskalyRuby::KassenSichV::TSS::Create do
  it 'inherits from "FiskalyRuby::KassenSichV::Base" class' do
    expect(described_class).to be < FiskalyRuby::KassenSichV::Base
  end

  describe '#call' do
    context 'with valid data' do
      include_context 'with a stubbed request', method: :put

      subject(:call) { described_class.new(token: 'some token', tss_id: tss_id).call }

      let(:tss_id) { ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id') }

      before { call }

      it 'makes a PUT request and receives a successful response', :aggregate_failures do
        expect(described_class).to have_received(:put)
        expect(call).to match(status: :ok, body: a_kind_of(Hash))
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

      it 'raises a RuntimeError exception' do
        create_tss = described_class.new(token: 'some_token', payload: { metadata: invalid_metadata })

        expect { create_tss.call }.to raise_error(RuntimeError, error_message)
      end
    end
  end

  describe '#tss_id' do
    it 'returns "tss_id attribute"' do
      expect(described_class.new(token: 'some_token', tss_id: 'some_tss').tss_id).to eq('some_tss')
    end
  end

  describe '#optional_payload_attributes' do
    it 'returns [:metadata]' do
      expect(described_class.new(token: 'some_token').optional_payload_attributes).to eq(%i(metadata))
    end
  end
end
