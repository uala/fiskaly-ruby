module FiskalyService
  module KassenSichV
    module Admin
      # Management APIs {https://developer.fiskaly.com/api/kassensichv/v2/#operation/logoutAdmin authenticate admin request}
      class Logout < Base
        attr_reader :token, :tss_id

        # @param token [String] JWT token
        # @param tss_id [String] ID of the TSS
        #
        # @return FiskalyService::KassenSichV::TSS::Admin::Logout
        def initialize(token:, tss_id:)
          super(token: token)
          @tss_id = tss_id
        end

        # Execute admin logout authentication
        #
        # @return [Hash] Formatted response informations
        def call
          response = self.class.post("/tss/#{tss_id}/admin/logout", headers: headers, body: body)
          handle_response(response)
        end
      end
    end
  end
end
