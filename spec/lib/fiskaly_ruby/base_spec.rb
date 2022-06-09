# frozen_string_literal: true

RSpec.describe FiskalyRuby::Base do
  describe '.to_method_name' do
    context 'with some usual command name' do
      let(:command) { stub_const('FiskalyRuby::Some::Usual::CommandName', Class.new(described_class)) }

      it 'returns relative method name' do
        expect(FiskalyRuby.command_to_method_name(command)).to eq('some_usual_command_name')
      end
    end

    context 'with particular command name' do
      context 'with KassenSichV module' do
        let(:command) { stub_const('FiskalyRuby::KassenSichV::Some::CommandName', Class.new(described_class)) }

        it 'returns relative method name' do
          expect(FiskalyRuby.command_to_method_name(command)).to eq('kassensichv_some_command_name')
        end
      end

      context 'with TSS module' do
        let(:command) { stub_const('FiskalyRuby::TSS::Some::CommandName', Class.new(described_class)) }

        it 'returns relative method name' do
          expect(FiskalyRuby.command_to_method_name(command)).to eq('tss_some_command_name')
        end
      end

      context 'with DSFinVK module' do
        let(:command) { stub_const('FiskalyRuby::DSFinVK::Some::CommandName', Class.new(described_class)) }

        it 'returns relative method name' do
          expect(FiskalyRuby.command_to_method_name(command)).to eq('dsfinvk_some_command_name')
        end
      end
    end
  end
end
