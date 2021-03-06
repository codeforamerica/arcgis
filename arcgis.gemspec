# encoding: utf-8
require File.expand_path('../lib/arcgis/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_development_dependency 'maruku', '~> 0.6'
  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rspec', '~> 2.6'
  gem.add_development_dependency 'simplecov', '~> 0.4'
  gem.add_development_dependency 'yard', '~> 0.7'
  gem.add_development_dependency 'webmock', '~> 1.6'

  gem.add_runtime_dependency 'faraday', '~> 0.7.4'
  gem.add_runtime_dependency 'faraday_middleware', '~> 0.7.0'
  gem.add_runtime_dependency 'multi_json', '~> 1.0.3'

  gem.author      = "Code for America"
  gem.description = %q{TODO: Write a gem description}
  gem.email       = 'info@codeforamerica.org'
  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.files       = `git ls-files`.split("\n")
  gem.homepage    = ''
  gem.name        = 'arcgis'
  gem.require_paths = ['lib']
  gem.summary     = %q{TODO: Write a gem summary}
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version     = ArcGIS::VERSION
end
