# frozen_string_literal: true

RSpec.describe FiskalyRuby::KassenSichV::TSS::ChangeAdminPin do
  describe 'ADMIN_PIN_REGEXP' do
    let(:char) { 'x' }

    context 'valid admin_pin' do
      it 'should match the regexp' do
        expect(described_class::ADMIN_PIN_REGEXP.match?(char * 6)).to be_truthy
        expect(described_class::ADMIN_PIN_REGEXP.match?(char.upcase * 6)).to be_truthy
      end
    end

    context 'invalid admin_pin' do
      it 'should not match the regexp' do
        expect(described_class::ADMIN_PIN_REGEXP.match?(char * 1)).to be_falsey
      end
    end
  end

  describe '#call' do
    context 'with valid data' do
      include_context 'with a stubbed request', method: :patch

      subject(:call) do
        described_class.new(
          token: ENV.fetch('RSPEC_FISKALY_BEARER_TOKEN', 'some_tss_token'),
          tss_id: ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id'),
          payload: {
            admin_puk: ENV.fetch('RSPEC_FISKALY_TSS_ADMIN_PUK', 'some-admin-puk'),
            new_admin_pin: ENV.fetch('RSPEC_FISKALY_TSS_ADMIN_PIN', '123456')
          }
        ).call
      end

      before { call }

      it 'makes a PATCH request and receives a successful response', :aggregate_failures do
        expect(described_class).to have_received(:patch)
        expect(call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end
  end

  describe '#body' do
    let(:authenticate) do
      described_class.new(
        token: 'some_token',
        tss_id: 'some_tss_id',
        payload: {
          admin_puk: 'some-admin-puk',
          new_admin_pin: '123456'
        }
      )
    end

    it 'should return the body' do
      expect(authenticate.body).to be_json_eql({
        admin_puk: authenticate.payload[:admin_puk],
        new_admin_pin: authenticate.payload[:new_admin_pin]
      }.to_json)
    end
  end
end
