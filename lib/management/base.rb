module FiskalyService
  module Management
    # Base class for {https://developer.fiskaly.com/api/management/v0 Management APIs}
    class Base < BaseRequest
      # Allowed country_code parameter values
      # This STANDARD is {https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3 ISO 3166-1 alpha-3}
      COUNTRY_CODES = %w(
        ABW AFG AGO AIA ALA ALB AND ARE ARG ARM ASM ATA ATF ATG AUS AUT AZE BDI BEL BEN BES BFA BGD BGR BHR BHS BIH
        BLM BLR BLZ BMU BOL BRA BRB BRN BTN BVT BWA CAF CAN CCK CHE CHL CHN CIV CMR COD COG COK COL COM CPV CRI CUB
        CUW CXR CYM CYP CZE DEU DJI DMA DNK DOM DZA ECU EGY ERI ESH ESP EST ETH FIN FJI FLK FRA FRO FSM GAB GBR GEO
        GGY GHA GIB GIN GLP GMB GNB GNQ GRC GRD GRL GTM GUF GUM GUY HKG HMD HND HRV HTI HUN IDN IMN IND IOT IRL IRN
        IRQ ISL ISR ITA JAM JEY JOR JPN KAZ KEN KGZ KHM KIR KNA KOR KWT LAO LBN LBR LBY LCA LIE LKA LSO LTU LUX LVA
        MAC MAF MAR MCO MDA MDG MDV MEX MHL MKD MLI MLT MMR MNE MNG MNP MOZ MRT MSR MTQ MUS MWI MYS MYT NAM NCL NER
        NFK NGA NIC NIU NLD NOR NPL NRU NZL OMN PAK PAN PCN PER PHL PLW PNG POL PRI PRK PRT PRY PSE PYF QAT REU ROU
        RUS RWA SAU SDN SEN SGP SGS SHN SJM SLB SLE SLV SMR SOM SPM SRB SSD STP SUR SVK SVN SWE SWZ SXM SYC SYR TCA
        TCD TGO THA TJK TKL TKM TLS TON TTO TUN TUR TUV TWN TZA UGA UKR UMI URY USA UZB VAT VCT VEN VGB VIR VNM VUT
        WLF WSM YEM ZAF ZMB ZWE
      ).freeze

      # Set HTTParty base url
      base_uri ENV.fetch('FISKALY_MANAGEMENT_BASE_URL', 'https://dashboard.fiskaly.com/api/v0')

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
