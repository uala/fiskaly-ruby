module FiskalyService
  module KassenSichV
    module TSS
      # Management APIs {https://developer.fiskaly.com/api/kassensichv/v2/#operation/createTss create tss request}
      #
      # Create a TSS
      #
      # This endpoint creates a TSS. The TSS is identified by a tss_id.
      # The tss_id must comply with the UUIDv4 standard and should be generated on your side.
      # When you create a TSS, its state is set to "CREATED".
      # The response for this endpoint will contain the admin PUK.
      # The administrator will need the PUK to set the admin PIN.
      # Make sure to store the PUK securely.
      # When the TSS has left the state "CREATED", you will no longer be able to see the PUK.
      # Use the Update a TSS endpoint to transition to state "UNINITIALIZED".
      class Create < Base
        attr_reader :tss_id

        # Optional payload attributes
        #
        # @return [Array] Set of optional attributes
        def optional_payload_attributes
          %i(metadata)
        end

        # @param token [String] JWT token
        # @param tss_id [String] TSS UUID
        # @param payload [Hash] Payload of request
        # @return [FiskalyService::KassenSichV::TSS::Create] The Create object
        def initialize(token:, tss_id: SecureRandom.uuid, payload: {})
          super(token: token, payload: payload)

          @tss_id = tss_id
        end

        # Execute tss creation
        #
        # @return [Hash] Formatted response informations
        def call
          _validate_params

          response = self.class.put("/tss/#{tss_id}", headers: headers, body: body)

          handle_response(response)
        end

        private

        # Validate parameters
        #
        # @return NilClass
        def _validate_params
          _validate_metadata
        end
      end
    end
  end
end
