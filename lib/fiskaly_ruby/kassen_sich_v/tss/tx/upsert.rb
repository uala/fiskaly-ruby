module FiskalyRuby
  module KassenSichV
    module TSS
      module Tx
        # Use this endpoint to change the state of a transaction.
        #
        # To start a transaction, set the state field of the request body to "ACTIVE". When you update the transaction, the state must also be set to "ACTIVE".
        #
        # There are two ways to end a transaction:
        #
        # If the transaction has finished as expected, set the state to "FINISHED".
        # If something went wrong and you want to cancel the transaction, set the state to "CANCELLED".
        # The query string for this endpoint must include the tx_revision parameter . Set tx_revision to 1 when you start the transaction. After each call, the tx_revision must be incremented. Pass an incremented tx_revision in the query string for the next call.
        #
        # All the data in the schema field of the request body must be UTF-8 encoded.
        #
        # When you start a transaction, the type and data of the transaction must be empty. This is required by the DSFinV-K (v2.1).
        #
        # Note: A TSS is only allowed to have 2000 open (type= "ACTIVE") transactions. In Case a TSS reaches this limit, you need to manually close (set to "CANCELLED" / "FINISHED", depending on your process) the open transactions.
        class Upsert < Base
          # Available Tx states
          STATES = %i(ACTIVE CANCELLED FINISHED).freeze

          attr_reader :tss_id, :tx_id_or_number, :tx_revision

          # Required payload attributes
          #
          # @return [Array] Set of required attributes
          def required_payload_attributes
            %i(state client_id)
          end

          # Optional payload attributes
          #
          # @return [Array] Set of optional attributes
          def optional_payload_attributes
            %i(schema metadata)
          end

          # @param token [String] JWT token
          # @param tss_id [String] TSS UUID
          # @param tx_id_or_number [String] Identifies a transaction by a tx_id (i.e. a self-generated UUIDv4) or a tx_number that gets assigned by us
          # @param tx_revision [Integer] Identifies an incremental counter (increment it on each tx update)
          # @param payload [Hash] Payload of request
          # @return [FiskalyRuby::KassenSichV::TSS::Tx::Upsert] The Upserted object
          def initialize(token:, tss_id:, tx_id_or_number: SecureRandom.uuid, tx_revision: 1, payload: {})
            super(token: token, payload: payload)

            @tss_id = tss_id
            @tx_id_or_number = tx_id_or_number
            @tx_revision = tx_revision
          end

          # Execute tx upsertion
          #
          # @return [Hash] Formatted response informations
          def call
            _validate_params

            response = self.class.put("/tss/#{tss_id}/tx/#{tx_id_or_number}", query: _query, headers: headers, body: body)

            handle_response(response)
          end

          private

          # Validate parameters
          #
          # @return NilClass
          def _validate_params
            _validate_metadata
            _validate_state
            _validate_schema
          end

          # Validate state parameter
          #
          # @return NilClass
          def _validate_state
            state = payload[:state]

            raise "Invalid state for: #{state.inspect}" unless STATES.include?(state)
          end

          # Request query params
          #
          # @return Hash
          def _query
            {
              tx_revision: tx_revision
            }
          end

          def _validate_schema
            schema = payload[:schema]
            state = payload[:state]

            if tx_revision > 1 && schema.nil? && state != :FINISHED
              error_message = <<~ERROR_MESSAGE
                Missing payload 'schema' attribute.
                When 'tx_revision' is greater then 1 and 'state' is different from :FINISHED
                then payload 'schema' attribute must be filled with this structure:
                {
                  schema: {
                    receipt: {
                      receipt_type:,
                      amounts_per_vat_rate: [
                        {
                          vat_rate:,
                          amount:
                        }
                      ],
                      amounts_per_payment_type: [
                        {
                          payment_type:,
                          amount:,
                          currency_code:
                        }
                      ]
                    }
                  }
                }
              ERROR_MESSAGE

              raise error_message
            end
          end
        end
      end
    end
  end
end
