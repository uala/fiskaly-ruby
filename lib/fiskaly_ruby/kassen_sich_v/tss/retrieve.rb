module FiskalyRuby
  module KassenSichV
    module TSS
      class Retrieve < Base
        # KassenSichV APIs {https://developer.fiskaly.com/api/kassensichv/v2/#operation/retrieveTss retrieve tss request}

        attr_reader :tss_id

        # @param token [String] JWT token
        # @param tss_id [String] TSS UUID
        def initialize(token:, tss_id:)
          super(token: token)

          @tss_id = tss_id
        end

        # Execute Retrieve List
        #
        # @return [Hash] Formatted response informations
        def call
          response = self.class.get("/tss/#{tss_id}", headers: headers, body: body)

          handle_response(response)
        end
      end
    end
  end
end
