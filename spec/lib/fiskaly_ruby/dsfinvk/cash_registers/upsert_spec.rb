RSpec.describe FiskalyRuby::DSFinVK::CashRegisters::Upsert do
  context 'unit tests' do
    let(:cash_register_upsert) do
      described_class.new(token: 'some_token', client_id: 'some_client_id')
    end

    describe 'Base class' do
      it 'expect to inherit from "FiskalyRuby::DSFinVK::Base" class' do
        expect(described_class).to be < FiskalyRuby::DSFinVK::Base
      end
    end

    describe '#required_payload_attributes' do
      it 'returns "required_payload_attributes" array' do
        expect(cash_register_upsert.required_payload_attributes).to match %i(cash_register_type brand model software base_currency_code)
      end
    end

    describe '#optional_payload_attributes' do
      it 'returns "optional_payload_attributes" array' do
        expect(cash_register_upsert.optional_payload_attributes).to match %i(processing_flags metadata)
      end
    end

    describe '#client_id' do
      it 'responds to "client_id"' do
        expect(cash_register_upsert.client_id).to eq('some_client_id')
      end
    end

    describe '#call' do
      let(:payload) do
        {
          cash_register_type: {
            type: 'MASTER',
            tss_id: 'some_tss_id'
          },
          brand: 'epson',
          model: 'rs232',
          software: {
            brand: 'Epson'
          },
          base_currency_code: 'EUR'
        }
      end
      let(:cash_register_upsert) do
        described_class.new(token: 'some_token', client_id: 'some_client_id', payload: payload)
      end

      context 'with valid params' do
        context 'with succeeded response' do
          before do
            allow(described_class).to receive(:put).and_return(ok_request)
          end

          let(:response) { instance_double(Net::HTTPOK, body: { foo: :bar }.to_json) }
          let(:ok_request) { instance_double(HTTParty::Response, success?: true, response: response) }

          it 'succeeded' do
            expect(described_class).to receive(:put).and_return(ok_request)
            expect(cash_register_upsert.call).to match({
              status: :ok,
              body: JSON.parse(ok_request.response.body)
            })
          end
        end

        context 'with failed response' do
          before do
            allow(described_class).to receive(:put).and_return(error_request)
          end

          let(:response) { instance_double(Net::HTTPBadRequest, message: 'Bad Request', body: {}.to_json) }
          let(:error_request) { instance_double(HTTParty::Response, success?: false, response: response) }

          it 'succeeded' do
            expect(described_class).to receive(:put).and_return(error_request)
            expect(cash_register_upsert.call).to match({
              status: :error,
              message: error_request.response.message,
              body: JSON.parse(error_request.response.body)
            })
          end
        end
      end

      context 'with invalid "brand"' do
        let(:cash_register_upsert) do
          described_class.new(token: 'some_token', client_id: 'some_client_id', payload: payload.merge({ brand: brand }))
        end

        context 'when is < 1 characters' do
          let(:brand) { '' }

          it 'raises error' do
            error_message = "Invalid brand for: '#{brand}', please use a 1-50 characters string"

            expect { cash_register_upsert.call }.to raise_error(RuntimeError, error_message)
          end
        end

        context 'when is > 50 characters' do
          let(:brand) { 'x' * 51 }

          it 'raises error' do
            error_message = "Invalid brand for: '#{brand}', please use a 1-50 characters string"

            expect { cash_register_upsert.call }.to raise_error(RuntimeError, error_message)
          end
        end
      end

      context 'with invalid "model"' do
        let(:cash_register_upsert) do
          described_class.new(token: 'some_token', client_id: 'some_client_id', payload: payload.merge({ model: model }))
        end

        context 'when is < 1 characters' do
          let(:model) { '' }

          it 'raises error' do
            error_message = "Invalid model for: '#{model}', please use a 1-50 characters string"

            expect { cash_register_upsert.call }.to raise_error(RuntimeError, error_message)
          end
        end

        context 'when is > 50 characters' do
          let(:model) { 'x' * 51 }

          it 'raises error' do
            error_message = "Invalid model for: '#{model}', please use a 1-50 characters string"

            expect { cash_register_upsert.call }.to raise_error(RuntimeError, error_message)
          end
        end
      end

      context 'with invalid "base_currency_code"' do
        let(:cash_register_upsert) do
          described_class.new(token: 'some_token', client_id: 'some_client_id', payload: payload.merge({ base_currency_code: '' }))
        end

        it 'raises error' do
          error_message = "Invalid base_currency_code for: '', please use a three characters uppercase format"

          expect { cash_register_upsert.call }.to raise_error(RuntimeError, error_message)
        end
      end
    end
  end

  context 'integration tests' do
    let(:kassen_sich_v_client_id) { ENV.fetch('RSPEC_FISKALY_CLIENT_ID', 'some_client_id') }
    let(:kassen_sich_v_tss_id) { ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id') }
    let(:dsfinvk_token) { ENV.fetch('RSPEC_FISKALY_TOKEN', 'some_fiskaly_token') }
    let(:payload) do
      {
        cash_register_type: {
          type: 'MASTER',
          tss_id: kassen_sich_v_tss_id
        },
        brand: 'epson',
        model: 'rs232',
        software: {
          brand: 'Epson'
        },
        base_currency_code: 'EUR'
      }
    end

    context 'with valid token', vcr: { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/cash_register_upsert_ok' } do
      let(:cash_register_upsert) do
        described_class.new(token: dsfinvk_token, client_id: kassen_sich_v_client_id, payload: payload)
      end

      it 'succeeded' do
        expect(cash_register_upsert.call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end

    context 'with invalid token', vcr: { tag: :fiskaly_service, cassette_name: 'fiskaly_service/dsfinvk/cash_register_upsert_error' } do
      let(:cash_register_upsert) do
        described_class.new(token: 'some_invalid_token', client_id: kassen_sich_v_client_id, payload: payload)
      end

      it 'failed' do
        expect(cash_register_upsert.call).to match(status: :error, body: a_kind_of(Hash), message: a_kind_of(String))
      end
    end
  end
end
