# frozen_string_literal: true

module FiskalyRuby
  module DSFinVK
    module CashPointClosing
      # DSFinVK APIs {https://developer.fiskaly.com/api/dsfinvk/v1#operation/insertCashPointClosing}
      #
      # Insert a cash point closing
      #
      # Attention: the processing of the data in this endpoint is asynchronous.
      # The answer to a request will return partial data including a state field.
      # This state field can have the following values: PENDING,WORKING,COMPLETED,CANCELLED,EXPIRED,DELETED,ERROR
      # When sending a request to this endpoint, only the schema and base data will be validated and the initial state returned will be PENDING.
      # In the background the data will be validated and persisted.
      # Once processing has finished the state will be either COMPLETED if successful, or ERROR if not.
      # In this case the field error will return the reason for the failure.
      # Attention: Only COMPLETED cash point closings will be considered for exports!
      class Create < Base
        attr_reader :closing_id

        def initialize(token:, closing_id: SecureRandom.uuid, payload: {})
          super(token: token, payload: payload)
          @closing_id = closing_id
        end

        # Required payload attributes
        #
        # @return [Array] Set of required attributes
        def required_payload_attributes
          %i(head cash_statement transactions client_id cash_point_closing_export_id)
        end

        # Execute cash point closing
        #
        # @return [Hash] Formatted response informations
        def call
          _validate_params

          response = self.class.put("/cash_point_closings/#{closing_id}", headers: headers, body: body)

          handle_response(response)
        end

        private

        # Validate parameters
        #
        # @return NilClass
        def _validate_params
          _validate_head
          _validate_cash_statement
          _validate_transactions
          _validate_cash_point_closing_export_id
        end

        def _validate_head
          head = payload[:head]

          raise "Invalid head for: #{head.inspect}, cannot be empty" if head.empty?
        end

        def _validate_cash_statement
          cash_statement = payload[:cash_statement]

          raise "Invalid cash_statement for: #{cash_statement.inspect}, cannot be empty" if cash_statement.empty?
        end

        def _validate_transactions
          transactions = payload[:transactions]

          raise "Invalid transactions for: #{transactions.inspect}, cannot be empty" if transactions.empty?
        end

        def _validate_client_id
          client_id = payload[:client_id]

          raise "Invalid client_id for: #{client_id.inspect}, cannot be empty" if client_id.empty?
        end

        def _validate_cash_point_closing_export_id
          cash_point_closing_export_id = payload[:cash_point_closing_export_id]

          raise "Invalid cash_point_closing_export_id for: #{cash_point_closing_export_id.inspect}, cannot be empty" if cash_point_closing_export_id.nil?
        end
      end
    end
  end
end
