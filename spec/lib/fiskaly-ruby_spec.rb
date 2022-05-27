# frozen_string_literal: true

RSpec.describe FiskalyRuby do
  before do
    allow(FiskalyRuby).to receive(:call).and_return(nil)
  end

  describe 'VERSION' do
    it 'has a version number' do
      expect(described_class::VERSION).not_to be nil
    end
  end

  describe 'COMMANDS' do
    described_class::COMMANDS.each do |command|
      method_name = command.to_method_name.to_sym

      describe ".#{method_name}" do
        let(:args) { { some: { random: :arguments } } }

        before do
          allow(command).to receive(:call).with(args)

          described_class.send(method_name, args)
        end

        it "should run #{command}#call and pass the same args" do
          expect(command).to have_received(:call).with(args)
        end
      end
    end
  end
end
