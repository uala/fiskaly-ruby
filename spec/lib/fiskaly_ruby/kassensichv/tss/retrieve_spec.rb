# frozen_string_literal: true

RSpec.describe FiskalyRuby::KassenSichV::TSS::Retrieve do
  it 'inherits from "FiskalyRuby::KassenSichV::Base" class' do
    expect(described_class).to be < FiskalyRuby::KassenSichV::Base
  end

  describe '#call' do
    subject(:call) { described_class.new(token: 'some token', tss_id: tss_id).call }

    context 'with valid data' do
      include_context 'with a stubbed request', method: :get

      let(:tss_id) { ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id') }

      before { call }

      it 'makes a GET request and receives a successful response', :aggregate_failures do
        expect(described_class).to have_received(:get)
        expect(call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end
  end
end
