module FiskalyRuby
  module KassenSichV
    # KassenShichV APIs {https://developer.fiskaly.com/api/kassensichv/v2/#tag/Authentication authentication request}
    #
    # Authenticate API
    #
    # To access our API, you need to have a valid JWT token. This endpoint creates the token with your api_key and
    # api_secret. If you don't have an api_key, you can create one via the fiskaly dashboard. The api_secret will be
    # generated for you after you create the api_key. The token must be sent with every following request in the
    # Authorization header field using the Bearer authentication scheme.
    class Authenticate < Base
      attr_reader :api_key, :api_secret

      # Overriding the parent initialize because this endpoint uses api_key/api_secret in place of token
      #
      # @param api_key [String] Fiskaly Api Key
      # @param api_secret [String] Fiskaly Api Secret
      #
      # @example
      #   FiskalyRuby::KassenSichV::Authenticate.call(api_key: "YOUR_API_KEY", api_secret: "YOUR_API_SECRET")
      #   => #<FiskalyRuby::KassenSichV::Authenticate:0x0000000131ec5279 @api_key="YOUR_API_KEY", @api_secret="YOUR_API_SECRET">
      #
      # @return FiskalyRuby::BaseRequest
      def initialize(api_key:, api_secret:)
        @api_key = api_key
        @api_secret = api_secret
      end

      # Execute authentication
      #
      # @return [Hash] Formatted response informations
      def call
        response = self.class.post('/auth', headers: headers, body: body)

        handle_response(response)
      end

      # Defines a defult body for requests
      #
      # @example Body
      #   FiskalyRuby::KassenSichV::Authenticate.call(api_key: "YOUR_API_KEY", api_secret: "YOUR_API_SECRET").body
      #   #=> "{\"api_key\":\"1234\",\"api_secret\":\"asdf\"}"
      #
      # @return [Hash]
      def body
        { api_key: api_key, api_secret: api_secret }.to_json
      end
    end
  end
end
