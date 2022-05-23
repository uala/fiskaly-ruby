require 'active_support/all'
require 'net/http'
require 'pry'

files = Dir[File.join('.', '/lib/fiskaly_ruby/**/*.rb')]
sorted_files = files.select { |f| f.include? '/base' } + files.reject { |f| f.include? '/base' }
sorted_files.delete './lib/fiskaly_ruby/base_request.rb'
sorted_files.prepend './lib/fiskaly_ruby/base_request.rb'
sorted_files.each { |f| require_relative f[6..] }

module FiskalyRuby
  VERSION = '0.1.0'.freeze

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
      name = command.name
      method_name = name.split('::')[1..].map do |command_name|
        if %(KassenSichV TSS DSFinVK).include?(command_name)
          command_name.downcase
        else
          command_name.gsub(/(.)([A-Z])/, '\1_\2').downcase
        end
      end.join('_')

      define_method(method_name) do |args|
         command.call(args)
      end
    end
  end
end
