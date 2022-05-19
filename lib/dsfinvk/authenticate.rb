module FiskalyService
  module DSFinVK
    # DSFinV-K APIs {https://developer.fiskaly.com/api/dsfinvk/v1#operation/authenticate}
    #
    # Authenticate API
    #
    # Our API uses JWT tokens to authenticate requests. API requests without authentication will fail. All API requests
    # have to be made over HTTPS, while requests made over plain HTTP will fail.
    #
    # If an /auth request using refresh_token fails in a 401 error, a regular /auth request with api_key and api_secret
    # must be sent.
    class Authenticate < Base
      attr_reader :api_key, :api_secret

      # Overrides the parent initialize because this endpoint uses api_key/api_secret in place of token
      #
      # @param api_key [String] Fiskaly Api Key
      # @param api_secret [String] Fiskaly Api Secret
      def initialize(api_key:, api_secret:)
        @api_key = api_key
        @api_secret = api_secret
      end

      # Authenticates using the auth endpoint
      #
      # @return [Hash] Formatted response informations
      def call
        response = self.class.post("/auth", headers: headers, body: _body)

        handle_response(response)
      end

      private

      def _body
        { api_key: api_key, api_secret: api_secret }.to_json
      end
    end
  end
end
