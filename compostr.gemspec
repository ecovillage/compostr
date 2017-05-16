# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'compostr/version'

Gem::Specification.new do |spec|
  spec.name          = "compostr"
  spec.version       = Compostr::VERSION
  spec.authors       = ["Felix Wolfsteller"]
  spec.email         = ["felix.wolfsteller@gmail.com"]

  spec.summary       = %q{Ease interaction with Custom Post Types of a Wordpress installation.}
  spec.description   = %q{One way to ask a wordpress installation about specific custom post type instances and tell it about them.}
  spec.homepage      = 'https://github.com/ecovillage/compostr'
  spec.licenses      = ['GPL-3.0+']

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rubypress"
  spec.add_dependency "mime-types"

  spec.add_development_dependency "minitest", '~> 5.0'
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
