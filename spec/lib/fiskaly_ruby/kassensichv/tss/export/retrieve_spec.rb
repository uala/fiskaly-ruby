# frozen_string_literal: true

RSpec.describe FiskalyRuby::KassenSichV::TSS::Export::Retrieve do
  it 'inherits from "FiskalyRuby::KassenSichV::Base" class' do
    expect(described_class).to be < FiskalyRuby::KassenSichV::Base
  end

  describe '#call' do
    context 'with valid data' do
      include_context 'with a stubbed request', method: :get

      subject(:call) { described_class.new(token: 'some_token', tss_id: tss_id, export_id: export_id).call }

      let(:tss_id) { ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id') }
      let(:export_id) { ENV.fetch('RSPEC_FISKALY_TSS_EXPORT_ID', '44bb4b44-b4b4-44b4-4bb4-4bbb4b4bbb44') }

      before { call }

      it 'makes a GET request and receives a successful response', :aggregate_failures do
        expect(described_class).to have_received(:get)
        expect(call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end
  end
end
