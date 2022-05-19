module FiskalyService
  module DSFinVK
    module CashRegisters
      class Retrieve < Base
        # DSFinVK APIs {https://developer.fiskaly.com/api/DSFinVK/CashRegisters/v2/#operation/retrieve retrieve cash register request}

        attr_reader :client_id

        # @param token [String] Fiskaly token
        # @param organization_id [String] Fiskaly client_id
        #
        # @return FiskalyService::BaseRequest
        def initialize(token:, client_id:)
          super(token: token)

          @client_id = client_id
        end

        # Execute cash register retrieve
        #
        # @return [Hash] Formatted response informations
        def call
          response = self.class.get("/cash_registers/#{client_id}", headers: headers, body: body)

          handle_response(response)
        end
      end
    end
  end
end
