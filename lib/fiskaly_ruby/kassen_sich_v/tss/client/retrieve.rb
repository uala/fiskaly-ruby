module FiskalyRuby
  module KassenSichV
    module TSS
      module Client
        # KassenSichV APIs {https://developer.fiskaly.com/api/kassensichv/tss/v2/#operation/retrieveTss retrieve client request}
        #
        class Retrieve < Base
          attr_reader :tss_id, :client_id

          # @param token [String] JWT token
          # @param tss_id [String] TSS UUID
          # @param client_id [String] TSS UUID
          # @return [FiskalyRuby::KassenSichV::TSS::Client::Retrieve] The retrieve object
          def initialize(token:, tss_id:, client_id:)
            super(token: token)

            @tss_id = tss_id
            @client_id = client_id
          end

          # Execute client retrieve
          #
          # @return [Hash] Formatted response informations
          def call
            response = self.class.get("/tss/#{tss_id}/client/#{client_id}", headers: headers, body: body)

            handle_response(response)
          end
        end
      end
    end
  end
end
