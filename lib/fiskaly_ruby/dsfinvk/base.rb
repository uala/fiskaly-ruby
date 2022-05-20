module FiskalyRuby
  module DSFinVK
    # Base class for {https://developer.fiskaly.com/api/dsfinvk/v1}
    class Base < FiskalyRuby::BaseRequest
      # Set HTTParty base url
      base_uri ENV.fetch('FISKALY_DSFINVK_BASE_URL', 'https://dsfinvk.fiskaly.com/api/v1')
    end
  end
end
