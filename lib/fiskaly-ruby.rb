# frozen_string_literal: true

require 'net/http'

require_relative 'fiskaly_ruby/base'
require_relative 'fiskaly_ruby/base_request'
require_relative 'fiskaly_ruby/dsfinvk/base'
require_relative 'fiskaly_ruby/kassen_sich_v/base'
require_relative 'fiskaly_ruby/management/base'

lib = File.expand_path('fiskaly_ruby', __dir__)
Dir["#{lib}/**/*.rb"].sort.each { |f| require f }

# A ruby gem that allows you to easily communicate with fiskaly service
module FiskalyRuby
  COMMANDS = [
    FiskalyRuby::Management::Authenticate,
    FiskalyRuby::Management::Organizations::Create,
    FiskalyRuby::Management::Organizations::Retrieve,
    FiskalyRuby::Management::Organizations::ApiKeys::Create,
    FiskalyRuby::Management::Organizations::ApiKeys::List,
    FiskalyRuby::KassenSichV::Authenticate,
    FiskalyRuby::KassenSichV::Admin::Authenticate,
    FiskalyRuby::KassenSichV::Admin::Logout,
    FiskalyRuby::KassenSichV::TSS::ChangeAdminPin,
    FiskalyRuby::KassenSichV::TSS::Create,
    FiskalyRuby::KassenSichV::TSS::Update,
    FiskalyRuby::KassenSichV::TSS::Retrieve,
    FiskalyRuby::KassenSichV::TSS::Client::Create,
    FiskalyRuby::KassenSichV::TSS::Client::Retrieve,
    FiskalyRuby::KassenSichV::TSS::Export::Retrieve,
    FiskalyRuby::KassenSichV::TSS::Export::RetrieveFile,
    FiskalyRuby::KassenSichV::TSS::Export::Trigger,
    FiskalyRuby::KassenSichV::TSS::Tx::Upsert,
    FiskalyRuby::DSFinVK::CashPointClosing::Create,
    FiskalyRuby::DSFinVK::CashRegisters::Retrieve,
    FiskalyRuby::DSFinVK::CashRegisters::Upsert,
    FiskalyRuby::DSFinVK::Authenticate,
    FiskalyRuby::DSFinVK::Exports::Download,
    FiskalyRuby::DSFinVK::Exports::Retrieve,
    FiskalyRuby::DSFinVK::Exports::Trigger
  ].freeze

  class << self
    COMMANDS.each do |command|
      define_method(command.to_method_name) do |args|
        command.call(args)
      end
    end
  end
end
