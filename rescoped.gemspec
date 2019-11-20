# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rescoped/version'

Gem::Specification.new do |spec|
  spec.name          = 'rescoped'
  spec.version       = Rescoped::VERSION
  spec.authors       = ['Geoff Ereth']
  spec.email         = ['github@geoffereth.com']
  spec.summary       = 'Remove includes or joins from an activerecord scope'
  spec.homepage      = 'https://github.com/gadogado/rescoped'
  spec.license       = 'MIT'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/gadogado/rescoped'
  spec.metadata['changelog_uri'] = 'https://github.com/gadogado/rescoped/master/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activerecord', '>= 4.0.0'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rubocop', '>= 0.76.0'
  spec.add_development_dependency 'sqlite3'
end
