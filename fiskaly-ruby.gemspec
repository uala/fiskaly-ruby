# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fiskaly_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'fiskaly-ruby'
  spec.version       = FiskalyRuby::VERSION
  spec.authors       = ['pietro ventimiglia']
  spec.email         = ['twntymls@gmail.com']

  spec.summary       = 'fiskaly service ruby component'
  spec.description   = 'A ruby gem that allows you to easily comunicate with fiskaly service'
  spec.homepage      = 'https://github.com/twentymls/fiskaly-ruby'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/twentymls/fiskaly-ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/twentymls/fiskaly-ruby/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['lib/**/*', 'LICENSE.txt', 'README.md', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md']
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'httparty', '~> 0.16'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
