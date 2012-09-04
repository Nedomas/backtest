# -*- encoding: utf-8 -*-
require File.expand_path('../lib/backtest/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nedomas"]
  gem.email         = ["domas.bitvinskas@me.com"]
  gem.description   = %q{A trading strategy backtesting gem.}
  gem.summary       = %q{A trading strategy backtesting gem.}
  gem.homepage      = "http://github.com/Nedomas/backtest"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "backtest"
  gem.require_paths = ["lib"]
  gem.version       = Backtest::VERSION

  gem.add_dependency 'rails'
  gem.add_dependency 'securities'
  gem.add_dependency 'indicators'
  gem.add_development_dependency 'rspec'
end
