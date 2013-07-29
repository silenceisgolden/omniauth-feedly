$:.push File.expand_path('../lib', __FILE__)
require 'omniauth/feedly/version'

Gem::Specification.new do |f|
    f.name = 'omniauth-feedly'
    f.version = Omniauth::Feedly::VERSION
    f.authors = ['AJ Klein']
    f.email = ['aj@buzzshift.com']
    f.summary = 'Feedly strategy for OmniAuth'
    f.executables = 'git ls-files -- bin/*'.split("\n").map{ |g| File.basename(g) }
    f.files = 'git ls-files'.split("\n")
    f.test_files = 'git ls-files -- {test,spec,features}/*'.split("\n")
    f.require_paths = ["lib"]
    f.add_dependency 'omniauth'
end