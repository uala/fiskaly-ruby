module FiskalyRuby
  module KassenSichV
    module TSS
      module Export
        # This endpoint triggers an export and returns a reference to the export resource.
        # Note: The query parameter client_id is not meant to be used in combination with other query parameters.
        # WARNING: triggering an export may interfere with the normal operations of the TSS. A large export can prevent the TSS from signing transaction data. Trigger exports when you don't need to sign transactions. For example, when doing a cash point closing.
        class Trigger < FiskalyRuby::KassenSichV::Base
          attr_reader :tss_id, :export_id

          # Optional payload attributes
          #
          # @return [Array] Set of optional attributes
          def optional_payload_attributes
            %i(client_id transaction_number start_transaction_number end_transaction_number start_date end_date
               maximum_number_records start_signature_counter end_signature_counter)
          end

          # @param token [String] JWT token
          # @param tss_id [String] TSS UUID
          # @param export_id [String] TSS UUID
          # @param payload [Hash] Payload of request
          # @return [FiskalyRuby::KassenSichV::TSS::Create] The Create object
          def initialize(token:, tss_id:, export_id: SecureRandom.uuid, payload: {})
            super(token: token, payload: payload)

            @tss_id = tss_id
            @export_id = export_id
          end

          # Execute tss creation
          #
          # @return [Hash] Formatted response informations
          def call
            _validate_params

            response = self.class.put("/tss/#{tss_id}/export/#{export_id}", headers: headers, body: body)

            handle_response(response)
          end

          private

          def _validate_params
            _validate_client_id
            _validate_digits_attributes
            _validate_integer_attributes
          end

          def _validate_client_id
            client_id = payload[:client_id]

            return if client_id.nil?

            raise "Invalid client_id for: #{client_id.inspect}, please use a string" unless client_id.is_a? String
          end

          def _validate_digits_attributes
            digit_attributes = payload.slice(*%i(transaction_number start_transaction_number end_transaction_number
                                                 maximum_number_records start_signature_counter end_signature_counter))

            digit_attributes.each do |attribute, value|
              raise "Invalid attribute for: #{attribute}, please use a digit string" unless /^\d+$/.match? value
            end
          end

          def _validate_integer_attributes
            integer_attributes = payload.slice(*%i(start_date end_date))

            integer_attributes.each do |attribute, value|
              raise "Invalid attribute for: #{attribute}, please use an integer" unless value.is_a? Integer
            end
          end
        end
      end
    end
  end
end
