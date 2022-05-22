RSpec.describe FiskalyRuby::BaseRequest do
  let(:token) { 'some_token' }
  let(:payload) { { some: :payload } }

  let(:base_request) { described_class.new(token: token, payload: payload) }

  let(:call) { described_class.call(token: token, payload: payload) }

  describe 'include "httparty"' do
    it 'should include "HTTParty"' do
      expect(described_class.include? HTTParty).to be_truthy
    end
  end

  describe '.new' do
    context 'without required arguments' do
      it 'expects to not initialize "FiskalyRuby::BaseRequest" object without `token` argument' do
        expect { described_class.new }.to raise_error(ArgumentError) { |error| expect(error.message).to eq 'missing keyword: :token' }
      end
    end
  end

  describe '.call' do
    it 'should raise "NotImplementedError" exception' do
      expect { call }.to(raise_error(NotImplementedError, "#{described_class} has not implemented method 'call'"))
    end
  end

  describe '#token' do
    it 'should return "token" attribute' do
      expect(described_class.new(token: token)).to respond_to(:token)
    end
  end

  describe '#payload' do
    it 'should return "payload" attribute' do
      expect(described_class.new(token: token, payload: payload)).to respond_to(:payload)
    end
  end

  describe '#call' do
    it 'should raise "NotImplementedError" exception' do
      expect { base_request.call }.to(
        raise_error(NotImplementedError, "#{described_class} has not implemented method 'call'")
      )
    end
  end

  describe '#required_payload_attributes' do
    it 'should return an array' do
      expect(base_request.required_payload_attributes).to eq([])
    end
  end

  describe '#optional_payload_attributes' do
    it 'should return an array' do
      expect(base_request.optional_payload_attributes).to eq([])
    end
  end

  describe '#handle_response' do
    context 'when the response is a success' do
      let(:response) { instance_double(Net::HTTPOK, body: { foo: :bar }.to_json) }
      let(:request) { instance_double(HTTParty::Response, success?: true, response: response) }

      it 'should return successful parsed response' do
        expect(base_request.handle_response(request)).to eq({
          status: :ok,
          body: { 'foo' => 'bar' }
        })
      end
    end

    context 'when the response is a failure' do
      let(:response) { instance_double(Net::HTTPUnauthorized, message: 'Bad request', body: { foo: :bar }.to_json) }
      let(:request) { instance_double(HTTParty::Response, success?: false, response: response) }

      it 'should return unsuccessful parsed response' do
        expect(base_request.handle_response(request)).to eq({
          status: :error,
          message: request.response.message,
          body: JSON.parse(request.response.body)
        })
      end
    end
  end

  describe '#headers' do
    it 'should return default headers hash' do
      expect(base_request.headers).to eq({ :'Content-Type' => 'application/json', Authorization: "Bearer #{base_request.token}" })
    end
  end

  describe '#body' do
    context 'with missing attributes' do
      it 'should raise error' do
        allow_any_instance_of(described_class).to receive(:required_payload_attributes).and_return(%i(x))

        expect { base_request.body }.to raise_error(RuntimeError, 'Missing required payload attributes: x')
      end
    end

    context 'with valid attributes' do
      it 'should return the JSON body' do
        allow_any_instance_of(described_class).to receive(:required_payload_attributes).and_return(base_request.payload.keys)
        allow_any_instance_of(described_class).to receive(:optional_payload_attributes).and_return([])

        expect(base_request.body).to be_json_eql({
          some: :payload
        }.to_json)
      end
    end
  end
end
