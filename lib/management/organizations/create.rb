module FiskalyService
  module Management
    module Organizations
      # Management APIs {https://developer.fiskaly.com/api/management/v0/#operation/createOrganization create organization request}
      #
      # Create Organization
      #
      # Create a new Organization
      class Create < Base
        # Regexp from the API documentation
        NAME_REGEXP = /^.{3,}$/

        # Required payload attributes
        #
        # @return [Array] Set of required attributes
        def required_payload_attributes
          %i(name address_line1 zip town country_code managed_by_organization_id)
        end

        # Optional payload attributes
        #
        # @return [Array] Set of optional attributes
        def optional_payload_attributes
          %i(display_name vat_id contact_person_id address_line2 state tax_number economy_id billing_options billing_address_id metadata)
        end

        # Execute organization creation
        #
        # @return [Hash] Formatted response informations
        def call
          _validate_params

          response = self.class.post('/organizations', headers: headers, body: body)

          handle_response(response)
        end

        private

        # Validate parameters
        #
        # @return NilClass
        def _validate_params
          _validate_name
          _validate_country_code
          _validate_metadata
        end

        # Validate name parameter
        #
        # @return NilClass
        def _validate_name
          name = payload[:name]

          raise "Invalid name for: #{name.inspect}, please use a lowercase >= 3 characters string" unless NAME_REGEXP.match?(name)
        end

        # Validate country_code parameter
        #
        # @return NilClass
        def _validate_country_code
          country_code = payload[:country_code]

          raise "Invalid country_code for: #{country_code.inspect}, please use one of these: #{COUNTRY_CODES}" unless COUNTRY_CODES.include?(country_code)
        end
      end
    end
  end
end
