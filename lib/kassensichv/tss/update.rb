module FiskalyService
  module KassenSichV
    module TSS
      # Management APIs {https://developer.fiskaly.com/api/kassensichv/v2/#operation/updateTss create tss request}
      #
      # Update a TSS
      #
      # When you create a TSS, its state is set to "CREATED". After creating the TSS, you need to deploy it. Deploying the TSS means starting a new SMAERS process associated with it. To deploy a TSS, set its state to "UNINITIALIZED".
      # This process may take longer than other requests. For this reason the timeout for updating to state "UNINITIALIZED" MUST be increased to at least 30 seconds!
      # If the update is not successful, the request should be repeated. It is recommended to perform this request during times with lower system load, such as the early morning or late evening.
      # After deploying the TSS, you need to initialize it. Only initialized TSS can process transactions. To initialize the TSS, set its state to "INITIALIZED". When initializing a TSS, a description may be provided.
      # If you don't need the TSS anymore, you can disable it. To disable the TSS, set its state to "DISABLED". Only the TSS in the states "UNINITIALIZED" or "INITIALIZED" can be disabled. Disabling a TSS is permanent and can't be undone.
      class Update < Base
        # Tss 'description' payload field regexp
        DESCRIPTION_REGEXP = /^[A-Za-z0-9 '()+,-.\/:=?]{0,100}$/

        # Available TSS states
        STATES = %i(UNINITIALIZED INITIALIZED DISABLED).freeze

        attr_reader :tss_id

        # Required payload attributes
        #
        # @return [Array] Set of required attributes
        def required_payload_attributes
          %i(state)
        end

        # Optional payload attributes
        #
        # @return [Array] Set of optional attributes
        def optional_payload_attributes
          %i(description metadata)
        end

        # @param token [String] JWT token
        # @param tss_id [String] TSS UUID
        # @param payload [Hash] Payload of request
        # @return [FiskalyService::KassenSichV::TSS::Update] The Update object
        def initialize(token:, tss_id:, payload: {})
          super(token: token, payload: payload)

          @tss_id = tss_id
        end

        # Execute tss update
        #
        # @return [Hash] Formatted response informations
        def call
          _validate_params

          response = self.class.patch("/tss/#{tss_id}", headers: headers, body: body)

          handle_response(response)
        end

        private

        # Validate parameters
        #
        # @return NilClass
        def _validate_params
          _validate_description
          _validate_states
          _validate_metadata
        end

        # Validate description parameter
        #
        # @return NilClass
        def _validate_description
          # description isn't a required parameter so we can skip validation if it's not present
          return unless JSON.parse(body).has_key? 'description'

          description = payload[:description]

          raise "Invalid description for: #{description.inspect}, it must be matched by this regexp: #{DESCRIPTION_REGEXP.inspect}" unless DESCRIPTION_REGEXP.match?(description)
        end

        # Validate states parameters
        #
        # @return NilClass
        def _validate_states
          state = payload[:state]

          raise "Invalid state for: #{state.inspect}" unless STATES.include?(state)
        end
      end
    end
  end
end
