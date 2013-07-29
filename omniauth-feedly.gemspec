require File.expand_path('omniauth/feedly/version', __FILE__)

Gem::Specification.new do |s|
    s.name = 'omniauth-feedly'
    s.version = Omniauth::Feedly::VERSION
    s.authors = ['AJ Klein']
    s.email = ['aj@buzzshift.com']
    s.summary = 'Feedly strategy for OmniAuth'
    s.executables = 'git ls-files -- bin/*'.split("\n").map{ |f| File.basename(f) }
    s.files = 'git ls-files'.split("\n")
    s.test_files = 'git ls-files -- {test,spec,features}/*'.split("\n")
    s.require_paths = ["lib"]
    s.add_dependency 'omniauth-oauth2'
end