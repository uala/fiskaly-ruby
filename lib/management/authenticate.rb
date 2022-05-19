module FiskalyService
  module Management
    # Management APIs {https://developer.fiskaly.com/api/management/v0/#operation/authenticate authentication request}
    #
    # Retrieve token
    #
    # Access to our API is only granted with a valid JWT / authorization token that must be obtained using this endpoint
    class Authenticate < Base
      attr_reader :api_key, :api_secret

      # @param api_key [String] Fiskaly Api Key
      # @param api_secret [String] Fiskaly Api Secret
      #
      # @example
      #   FiskalyService::Management::Authenticate.call(api_key: "YOUR_API_KEY", api_secret: "YOUR_API_SECRET")
      #   => #<FiskalyService::Management::Authenticate:0x0000000131ec5279 @api_key="YOUR_API_KEY", @api_secret="YOUR_API_SECRET">
      #
      # @return FiskalyService::BaseRequest
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
      #   FiskalyService::Management::Authenticate.call(api_key: "YOUR_API_KEY", api_secret: "YOUR_API_SECRET").body
      #   #=> "{\"api_key\":\"1234\",\"api_secret\":\"asdf\"}"
      #
      # @return [Hash]
      def body
        { api_key: api_key, api_secret: api_secret }.to_json
      end
    end
  end
end
