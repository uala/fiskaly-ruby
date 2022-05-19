module FiskalyService
  module KassenSichV
    module TSS
      # KassenSichV APIs {https://developer.fiskaly.com/api/kassensichv/v2/#operation/changeAdminPin authenticate admin request}
      class ChangeAdminPin < Base
        # Rule from the API documentation
        ADMIN_PIN_REGEXP = /^[a-z0-9A-Z\-]{6,}$/

        attr_reader :token, :tss_id

        # @param token [String] JWT token
        # @param tss_id [String] ID of the TSS
        #
        # @return FiskalyService::KassenSichV::TSS::Admin::ChangeAdminPin
        def initialize(token:, tss_id:, payload: {})
          super(token: token, payload: payload)

          @tss_id = tss_id
        end

        # Required payload attributes
        #
        # @return [Array] Set of required attributes
        def required_payload_attributes
          %i(new_admin_pin admin_puk)
        end

        # Execute change admin pin
        #
        # @return [Hash] Formatted response informations
        def call
          _validate_params

          response = self.class.patch("/tss/#{tss_id}/admin", headers: headers, body: body)
          handle_response(response)
        end

        private

        def _validate_params
          _validate_new_admin_pin
        end

        def _validate_new_admin_pin
          new_admin_pin = payload[:new_admin_pin]

          raise "Invalid admin_pin for: #{new_admin_pin.inspect}, please use a >= 3 characters string" unless ADMIN_PIN_REGEXP.match?(new_admin_pin)
        end
      end
    end
  end
end
