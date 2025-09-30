# -*- encoding: utf-8 -*-
require File.expand_path('../lib/adva_blog/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Micah Geisel"]
  gem.email         = ["micah@botandrose.com"]
  gem.description   = %q{Adva Blog}
  gem.summary       = %q{Engine for Adva CMS blog component}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "adva_blog"
  gem.require_paths = ["lib"]
  gem.version       = AdvaBlog::VERSION

  gem.add_dependency "adva"

  gem.add_development_dependency "rspec-rails"
  gem.add_development_dependency "rails-controller-testing", "~> 1.0"

  gem.add_development_dependency "appraisal"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "simplecov-html"
  gem.add_development_dependency "debug"
end
