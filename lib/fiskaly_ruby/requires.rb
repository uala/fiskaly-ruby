# frozen_string_literal: true

require 'net/http'

require_relative 'base'
require_relative 'base_request'
require_relative 'dsfinvk/base'
require_relative 'kassen_sich_v/base'
require_relative 'management/base'

lib = File.expand_path(__dir__)
Dir["#{lib}/**/*.rb"].sort.each { |f| require f }
