# frozen_string_literal: true

module FiskalyRuby
  module DSFinVK
    module CashRegisters
      # DSFinVK APIs {https://developer.fiskaly.com/api/DSFinVK/CashRegisters/v2/#operation/retrieve retrieve cash register request}
      #
      class Retrieve < Base
        attr_reader :client_id

        # @param token [String] Fiskaly token
        # @param organization_id [String] Fiskaly client_id
        #
        # @return FiskalyRuby::BaseRequest
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
