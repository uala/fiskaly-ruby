# frozen_string_literal: true

module FiskalyRuby
  module KassenSichV
    module TSS
      module Export
        # Returns an export resource.
        #
        # This resource holds the state of the asynchronous generation of a TAR file that (is ought to) contain(s) the
        # initialization information, the log messages, and the certificate(s) required for the verification of the log
        # messages.
        #
        # A successfully created export file is available until the time specified by the time_expiration attribute.
        class Retrieve < Base
          attr_reader :tss_id, :export_id

          # @param token [String] JWT token
          # @param tss_id [String] TSS UUID
          # @param export_id [String] Identifies an Export
          # @return [FiskalyRuby::KassenSichV::TSS::Export::Retrieve] The Retrieved object
          def initialize(token:, tss_id:, export_id:)
            super(token: token)

            @tss_id = tss_id
            @export_id = export_id
          end

          # Retrive the informations about a specific export
          #
          # @return [Hash] Formatted response informations
          def call
            response = self.class.get("/tss/#{tss_id}/export/#{export_id}", headers: headers)

            handle_response(response)
          end
        end
      end
    end
  end
end
