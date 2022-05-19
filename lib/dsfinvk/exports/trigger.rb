module FiskalyService
  module DSFinVK
    module Exports
      # Trigger an export.
      #
      # Attention: the processing of the data in this endpoint is asyncronous. The answer to a request will return base
      # export data including a state field. This state field can have the following values: PENDING,WORKING,COMPLETED,
      # CANCELLED,EXPIRED,DELETED,ERROR When sending a request to this endpoint, only the schema and base data will be
      # validated and the initial state returned will be PENDING. In the background the export will be performed. Once
      # processing has finished the state will be either COMPLETED if successful, or ERROR if not. In this case the
      # field error will return the reason for the failure.
      #
      #   Once successfully finished you can download the export with a separate call.
      class Trigger < FiskalyService::DSFinVK::Base
        attr_reader :export_id

        # Required payload attributes
        #
        # @return [Array] Set of required attributes
        def required_payload_attributes
          %i(start_date end_date)
        end

        # Optional payload attributes
        #
        # @return [Array] Set of optional attributes
        def optional_payload_attributes
          %i(client_id metadata)
        end

        # @param token [String] Access token
        # @param export_id [String] DSFinV-K export UUID
        # @param payload [Hash] Payload of request
        def initialize(token:, export_id: SecureRandom.uuid, payload: {})
          super(token: token, payload: payload)

          @export_id = export_id
        end

        # Triggers a DSFinV-K export
        #
        # @return [Hash] Formatted response informations
        def call
          _validate_context

          response = self.class.put("/exports/#{export_id}", headers: headers, body: body)

          handle_response(response)
        end

        private

        def _validate_context
          date_attributes = payload.slice(*%i(start_date end_date))

          date_attributes.each do |attribute, value|
            raise "Invalid attribute for: #{attribute}, please use an integer" unless value.is_a? Integer
          end
        end
      end
    end
  end
end
