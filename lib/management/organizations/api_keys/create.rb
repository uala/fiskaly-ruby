module FiskalyService
  module Management
    module Organizations
      module ApiKeys
        # Management APIs {https://developer.fiskaly.com/api/management/v0/#operation/createApiKey create api key request}
        #
        # Create API Key
        #
        # Create an API Key
        class Create < Base
          # Regexp from the API documentation
          NAME_REGEXP = /^[a-z0-9\-]{3,30}$/

          # Allowed status parameter values
          STATUSES = %i(enabled disabled).freeze

          attr_reader :organization_id

          # Required payload attributes
          #
          # @return [Array] Set of required attributes
          def required_payload_attributes
            %i(name status)
          end

          # Optional payload attributes
          #
          # @return [Array] Set of optional attributes
          def optional_payload_attributes
            %i(managed_by_organization_id metadata)
          end

          def initialize(token:, organization_id:, payload: {})
            super(token: token, payload: payload)

            @organization_id = organization_id
          end

          # Execute apikeys creation
          #
          # @return [Hash] Formatted response informations
          def call
            _validate_params

            response = self.class.post("/organizations/#{organization_id}/api-keys", headers: headers, body: body)

            handle_response(response)
          end

          private

          # Validate parameters
          def _validate_params
            _validate_name
            _validate_status
            _validate_metadata
          end

          # Validate name parameter
          def _validate_name
            name = payload[:name]

            raise "Invalid name for: #{name.inspect}, please use a lowercase 3 to 30 characters string" unless NAME_REGEXP.match?(name)
          end

          # Validate status parameter
          def _validate_status
            status = payload[:status]

            raise "Invalid status for: #{status.inspect}" unless STATUSES.include?(status)
          end
        end
      end
    end
  end
end
