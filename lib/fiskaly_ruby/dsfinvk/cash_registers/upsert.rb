# frozen_string_literal: true

module FiskalyRuby
  module DSFinVK
    module CashRegisters
      # DSFinVK APIs for {https://developer.fiskaly.com/api/dsfinvk/v1#operation/upsertCashRegister cash register upsert}
      #
      # DSFinV-K cash register upsert
      #
      # Insert or update a cash register/slave when a client already exists.
      class Upsert < Base
        BRAND_MODEL_LENGTH_RANGE = (1..50).freeze
        BASE_CURRENCY_CODE_REGEXP = /^[A-Z]{3}$/.freeze

        attr_reader :client_id

        # Required payload attributes
        #
        # @return [Array] Set of required attributes
        def required_payload_attributes
          %i(cash_register_type brand model software base_currency_code)
        end

        # Optional payload attributes
        #
        # @return [Array] Set of optional attributes
        def optional_payload_attributes
          %i(processing_flags metadata)
        end

        def initialize(token:, client_id:, payload: {})
          super(token: token, payload: payload)

          @client_id = client_id
        end

        # Execute cash register creation
        #
        # @return [Hash] Formatted response informations
        def call
          _validate_params

          response = self.class.put("/cash_registers/#{client_id}", headers: headers, body: body)

          handle_response(response)
        end

        private

        # Validate parameters
        #
        # @return NilClass
        def _validate_params
          _validate_brand
          _validate_model
          _validate_base_currency_code
        end

        # Validate brand parameter
        def _validate_brand
          brand = payload[:brand]

          raise "Invalid brand for: '#{brand}', please use a 1-50 characters string" unless BRAND_MODEL_LENGTH_RANGE === brand.length
        end

        # Validate model parameter
        def _validate_model
          model = payload[:model]

          raise "Invalid model for: '#{model}', please use a 1-50 characters string" unless BRAND_MODEL_LENGTH_RANGE === model.length
        end

        # Validate base_currency_code parameter
        def _validate_base_currency_code
          base_currency_code = payload[:base_currency_code]

          return if BASE_CURRENCY_CODE_REGEXP.match? base_currency_code

          raise "Invalid base_currency_code for: '#{base_currency_code}', please use a three characters uppercase format"
        end
      end
    end
  end
end
