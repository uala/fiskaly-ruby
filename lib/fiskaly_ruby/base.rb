# frozen_string_literal: true

module FiskalyRuby
  # Base class
  class Base
    def self.to_method_name
      name.split('::')[1..].map do |command_name|
        if %w(KassenSichV TSS DSFinVK).include?(command_name)
          command_name.downcase
        else
          command_name.gsub(/(.)([A-Z])/, '\1_\2').downcase
        end
      end.join('_')
    end
  end
end
