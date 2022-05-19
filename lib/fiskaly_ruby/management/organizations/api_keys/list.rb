module FiskalyRuby
  module Management
    module Organizations
      module ApiKeys
        # Management APIs {https://developer.fiskaly.com/api/management/v0/#operation/listApiKeys retrieve api keys}

        # Retrieve API Keys
        class List < Base
          attr_reader :organization_id, :query

          # @param token [String] Fiskaly token
          # @param organization_id [String] Fiskaly organization_id
          # @param query [String] query param
          #
          # @return FiskalyRuby::BaseRequest
          def initialize(token:, organization_id:, query:)
            super(token: token)

            @organization_id = organization_id
            @query = query
          end

          # Execute apikeys List
          #
          # @return [Hash] Formatted response informations
          def call
            response = self.class.get("/organizations/#{organization_id}/api-keys", headers: headers, body: body, query: query)

            handle_response(response)
          end
        end
      end
    end
  end
end
