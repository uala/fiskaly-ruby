module FiskalyRuby
  VERSION = '0.1.0'

  COMMANDS = [
    FiskalyService::Management::Authenticate,
    FiskalyService::Management::Organizations::Create,
    FiskalyService::Management::Organizations::Retrieve,
    FiskalyService::Management::Organizations::ApiKeys::Create,
    FiskalyService::Management::Organizations::ApiKeys::List,
    FiskalyService::KassenSichV::Authenticate,
    FiskalyService::KassenSichV::Admin::Authenticate,
    FiskalyService::KassenSichV::Admin::Logout,
    FiskalyService::KassenSichV::TSS::Client::Create,
    FiskalyService::KassenSichV::TSS::Client::Retrieve,
    FiskalyService::KassenSichV::TSS::Export::Retrieve,
    FiskalyService::KassenSichV::TSS::Export::RetrieveFile,
    FiskalyService::KassenSichV::TSS::Export::Trigger,
    FiskalyService::KassenSichV::TSS::Tx::Upsert
  ]

  class << self
    COMMANDS.each do |command|
      name = command.name
      method_name = name.split('::')[1..].map do |command_name|
         case command_name
         when 'KassenSichV' then command_name.downcase
         when 'TSS' then command_name.downcase
         else command_name.gsub(/(.)([A-Z])/, '\1_\2').downcase
         end
      end.join('_')

      define_method(method_name) do |args|
         command.call(args)
      end
    end
  end
end
