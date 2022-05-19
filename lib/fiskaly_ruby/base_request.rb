require 'httparty'

module FiskalyRuby
  class BaseRequest
    include HTTParty

    # Useful for subclasses requests
    attr_reader :token, :payload

    # Set instance `call` method also as class method
    #
    # @param args [Array] List of arguments to pass to `call` instance method
    #
    # @return [NotImplementedError] If `call` method is not defined in subclass
    def self.call(**args)
      new(**args).call
    end

    # @param token [String] Fiskaly Bearer Token
    #
    # @example
    #   FiskalyRuby::BaseRequest.new(token: "YOUR_TOKEN")
    #   => #<FiskalyRuby::BaseRequest:0x0000000131ec5279 @token="YOUR_TOKEN">
    #
    # @return FiskalyRuby::BaseRequest
    def initialize(token:, payload: {})
      @token = token
      @payload = payload
    end

    # Helps to remember to implement `call` method in subclasses
    #
    # @example Call
    #   FiskalyRuby::BaseRequest.new(token: 'asdf').call
    #   #=> NotImplementedError: FiskalyRuby::BaseRequest has not implemented method 'call'
    #
    # @raise [NotImplementedError] If `call` method is not defined in subclass
    def call
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    # Required payload attributes, redefine this method if you need to declare them
    #
    # @return [Array] Default value
    def required_payload_attributes
      []
    end

    # Optional payload attributes, redefine this method if you need to declare them
    #
    # @return [Array] Default value
    def optional_payload_attributes
      []
    end

    # Handles request to return appropiate response based on successful or failed request
    #
    # @param request [HTTParty::Response] HTTParty executed request
    # => { status: :ok, body: { 'foo' => 'bar' } }
    #
    # @example Handle response
    #   FiskalyRuby::BaseRequest.new(token: 'asdf').handle(request)
    #   #=> { status: :ok, body: JSON.parse(request.response.body) }
    #
    # @return [Hash] Formatted response informations
    def handle_response(request)
      if request.success?
        {
          status: :ok,
          body: JSON.parse(request.response.body)
        }
      else
        {
          status: :error,
          message: request.response.message,
          body: JSON.parse(request.response.body)
        }
      end
    end

    # Defines a default headers for requests
    #
    # @example Headers
    #   FiskalyRuby::BaseRequest.new(token: 'asdf').headers
    #   #=> { :'Content-Type' => 'application/json' }
    #
    # @return [Hash]
    def headers
      { :'Content-Type' => 'application/json', Authorization: "Bearer #{token}" }
    end

    # Helps to remember to implement `body` method in subclasses
    #
    # @example Body
    #   FiskalyRuby::BaseRequest.new(token: 'asdf').body
    #   #=> NotImplementedError: FiskalyRuby::BaseRequest has not implemented method 'body'
    #
    # @raise [NotImplementedError] If `body` method is not defined in subclass
    def body
      _validate_payload_required_attributes

      _filter_payload_with_allowed_attributes.to_json
    end

    private

    # Payload required attributes validation, checks and notifies you if some attributes are missing
    def _validate_payload_required_attributes
      missing_attributes = required_payload_attributes - payload.keys

      raise "Missing required payload attributes: #{missing_attributes.join(', ')}" if missing_attributes.any?
    end

    # Filter payload with allowed attributes, removes unnecessary attributes from the payload
    def _filter_payload_with_allowed_attributes
      payload.slice(*(required_payload_attributes + optional_payload_attributes))
    end
  end
end
