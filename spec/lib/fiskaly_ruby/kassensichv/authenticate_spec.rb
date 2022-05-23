# frozen_string_literal: true

RSpec.describe FiskalyRuby::KassenSichV::Authenticate do
  it 'inherits from "FiskalyRuby::KassenSichV::Base" class' do
    expect(described_class).to be < FiskalyRuby::KassenSichV::Base
  end

  describe 'initialize' do
    context 'without the required arguments' do
      subject(:authenticate) { described_class.new }

      it { expect { authenticate }.to raise_exception(ArgumentError, /missing keywords: :api_key, :api_secret/) }
    end
  end

  describe '#call' do
    context 'when the response is a success' do
      include_context 'with a stubbed request', method: :post, response_body: { 'access_token' => '<Access Token>' }

      subject(:call) { described_class.new(api_key: 'some key', api_secret: 'some secret...').call }

      before { call }

      it 'returns the successful response', :aggregate_failures do
        expect(described_class).to have_received(:post)
        expect(call).to match(status: :ok, body: http_response_body)
      end
    end

    context 'when the response is a failure' do
      subject(:call) { described_class.new(api_key: 'some key', api_secret: 'some secret...').call }

      let(:response) { instance_double(HTTParty::Response, success?: false, response: http_response) }
      let(:http_response) { instance_double(Net::HTTPResponse, body: http_response_body.to_json, message: 'A message') }
      let(:http_response_body) { { 'access_token' => '<Access Token>' } }

      before do
        allow(described_class).to receive(:post).and_return(response)
        call
      end

      it 'returns the failure response', :aggregate_failures do
        expect(described_class).to have_received(:post)
        expect(call).to match(status: :error, message: 'A message', body: http_response_body)
      end
    end
  end

  describe '.call' do
    include_context 'with a stubbed request', method: :post, response_body: { 'access_token' => '<Access Token>' }

    subject(:authenticate) { described_class.call(args) }

    let(:args) { { api_key: 'some key', api_secret: 'some secret...' } }
    let(:authenticate_instance) { described_class.new(args) }

    before do
      allow(described_class).to receive(:new).and_return(authenticate_instance)
      allow(authenticate_instance).to receive(:call).and_call_original
    end

    it 'creates a new instance and call "call" method on it', :aggregate_failures do
      authenticate
      expect(described_class).to have_received(:new).with(args)
      expect(authenticate_instance).to have_received(:call)
      expect(described_class).to have_received(:post)
    end
  end
end
