module FiskalyService
  # @note "Kassen Sich V" refers to german checkout
  module KassenSichV
    # Base class for {https://developer.fiskaly.com/api KassenShichV APIs}
    class Base < BaseRequest
      # Set HTTParty base url
      base_uri ENV.fetch('FISKALY_KASSENSICHV_BASE_URL', 'https://kassensichv-middleware.fiskaly.com/api/v2')

      protected

      # Validate metadata parameter
      #
      # @return NilClass
      def _validate_metadata
        # metadata isn't a required parameter so we can skip validation if it's not present
        return unless JSON.parse(body).has_key? 'metadata'

        metadata = payload[:metadata]

        unless metadata.is_a?(Hash)
          raise(
            <<~ERROR_MESSAGE
              Invalid 'metadata' type: #{metadata.class.inspect}, please use a Hash.
              You can use this parameter to attach custom key-value data to an object.
              Metadata is useful for storing additional, structured information on an object.
              Note: You can specify up to 20 keys,
              with key names up to 40 characters long and values up to 500 characters long.
            ERROR_MESSAGE
          )
        end
      end
    end
  end
end
