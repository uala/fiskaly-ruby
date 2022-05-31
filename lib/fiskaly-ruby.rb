# frozen_string_literal: true

require_relative 'fiskaly_ruby/requires'

# A ruby gem that allows you to easily communicate with fiskaly service
module FiskalyRuby
  COMMANDS = [
    Management::Authenticate,
    Management::Organizations::Create,
    Management::Organizations::Retrieve,
    Management::Organizations::ApiKeys::Create,
    Management::Organizations::ApiKeys::List,
    KassenSichV::Authenticate,
    KassenSichV::Admin::Authenticate,
    KassenSichV::Admin::Logout,
    KassenSichV::TSS::ChangeAdminPin,
    KassenSichV::TSS::Create,
    KassenSichV::TSS::Update,
    KassenSichV::TSS::Retrieve,
    KassenSichV::TSS::Client::Create,
    KassenSichV::TSS::Client::Retrieve,
    KassenSichV::TSS::Export::Retrieve,
    KassenSichV::TSS::Export::RetrieveFile,
    KassenSichV::TSS::Export::Trigger,
    KassenSichV::TSS::Tx::Upsert,
    DSFinVK::CashPointClosing::Create,
    DSFinVK::CashRegisters::Retrieve,
    DSFinVK::CashRegisters::Upsert,
    DSFinVK::Authenticate,
    DSFinVK::Exports::Download,
    DSFinVK::Exports::Retrieve,
    DSFinVK::Exports::Trigger
  ].freeze

  class << self
    COMMANDS.each do |command|
      define_method(command.to_method_name) do |args|
        command.call(args)
      end
    end
  end
end
