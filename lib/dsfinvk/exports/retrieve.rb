module FiskalyService
  module DSFinVK
    module Exports
      # DSFinVK APIs for {https://developer.fiskaly.com/api/dsfinvk/v1#operation/retrieveExport exports retrieve}
      #
      # DSFinV-K export retrieve
      #
      # Returns DSFinV-K export resource.
      class Retrieve < Base
        attr_reader :export_id

        # @param token [String] JWT token
        # @param export_id [String] Identifies an Export
        # @return [FiskalyService::KassenSichV::TSS::Export::Retrieve] The Retrieved object
        def initialize(token:, export_id:)
          super(token: token)

          @export_id = export_id
        end

        # Retrive the informations about a specific export
        #
        # @return [Hash] Formatted response informations
        def call
          response = self.class.get("/exports/#{export_id}", headers: headers)

          handle_response(response)
        end
      end
    end
  end
end
