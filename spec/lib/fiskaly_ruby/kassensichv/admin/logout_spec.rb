# frozen_string_literal: true

RSpec.describe FiskalyRuby::KassenSichV::Admin::Logout do
  describe '#call' do
    context 'with valid parameters' do
      let(:authenticate) do
        described_class.new(
          token: ENV.fetch('RSPEC_FISKALY_BEARER_TOKEN', 'some_bearer_token'),
          tss_id: ENV.fetch('RSPEC_FISKALY_TSS_ID', 'some_tss_id')
        )
      end

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/admin_logout_ok' }
      it 'should authenticate admin', vcr: vcr_options do
        expect(authenticate.call).to match(status: :ok, body: a_kind_of(Hash))
      end
    end

    context 'with fiskaly errors' do
      let(:authenticate) do
        described_class.new(
          token: ENV.fetch('RSPEC_FISKALY_BEARER_TOKEN', 'some_bearer_token'),
          tss_id: 'some_tss_id'
        )
      end

      vcr_options = { tag: :fiskaly_service, cassette_name: 'fiskaly_service/kassensichv/admin_logout_error' }
      it 'should not authenticate admin', vcr: vcr_options do
        expect(authenticate.call).to match(status: :error, message: 'Bad Request', body: a_kind_of(Hash))
      end
    end
  end

  describe '#body' do
    let(:authenticate) do
      described_class.new(
        token: 'some_token',
        tss_id: 'some_tss_id'
      )
    end

    it 'should return the body' do
      expect(authenticate.body).to be_json_eql({}.to_json)
    end
  end
end
