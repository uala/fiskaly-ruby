module FiskalyService
  module KassenSichV
    module Admin
      # Management APIs {https://developer.fiskaly.com/api/kassensichv/v2/#operation/authenticateAdmin authenticate admin request}
      class Authenticate < Base
        attr_reader :tss_id

        # Rule from the API documentation
        ADMIN_PIN_REGEXP = /^[a-z0-9A-Z\-]{6,}$/

        def initialize(token:, tss_id:, payload: {})
          super(token: token, payload: payload)

          @tss_id = tss_id
        end

        # Required payload attributes
        #
        # @return [Array] Set of required attributes
        def required_payload_attributes
          %i(admin_pin)
        end

        # Execute admin authentication
        #
        # @return [Hash] Formatted response informations
        def call
          _validate_params

          response = self.class.post("/tss/#{tss_id}/admin/auth", headers: headers, body: body)
          handle_response(response)
        end

        private

        # Validate parameters
        #
        # @return NilClass
        def _validate_params
          _validate_admin_pin
        end

        # Validate admin_pin parameter
        #
        # @return NilClass
        def _validate_admin_pin
          admin_pin = payload[:admin_pin]

          raise "Invalid admin_pin for: #{admin_pin.inspect}" unless ADMIN_PIN_REGEXP.match?(admin_pin)
        end
      end
    end
  end
end
