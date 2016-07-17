require_relative './source/rip/package/about'

Gem::Specification.new do |spec|
  spec.name          = 'rip-package'
  spec.version       = Rip::Package::About.version
  spec.author        = 'Thomas Ingram'
  spec.license       = 'MIT'
  spec.summary       = 'Ruby package metadata for Rip'
  spec.homepage      = 'http://www.rip-lang.org/'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = [ 'source' ]

  spec.add_runtime_dependency 'hashie'
  spec.add_runtime_dependency 'semverse'
  spec.add_runtime_dependency 'tomlrb'

  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'rake'
end
