# frozen_string_literal: true

module FiskalyRuby
  module Management
    module Organizations
      # Management APIs {https://developer.fiskaly.com/api/management/organization/v0/#operation/retrieveOrganization retrieve organization}
      #
      # Retrieve Organization
      #
      class Retrieve < Base
        attr_reader :organization_id

        # @param token [String] Fiskaly token
        # @param organization_id [String] Fiskaly organization_id
        #
        # @return FiskalyRuby::BaseRequest
        def initialize(token:, organization_id:)
          super(token: token)
          @organization_id = organization_id
        end

        # Execute organization creation
        #
        # @return [Hash] Formatted response informations
        def call
          response = self.class.get("/organizations/#{organization_id}", headers: headers, body: body)

          handle_response(response)
        end
      end
    end
  end
end
