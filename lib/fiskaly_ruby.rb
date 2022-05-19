module FiskalyRuby
	VERSION = '0.1.0'

	def self.management_authenticate(args = {})
		FiskalyService::Management::Authenticate.call(api_key: args.fetch(:api_key), api_secret: args.fetch(:api_secret))
	end
end