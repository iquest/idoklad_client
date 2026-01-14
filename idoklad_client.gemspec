Gem::Specification.new do |s|
  s.name        = 'idoklad_client'
  s.version     = '0.0.1'
  s.summary     = 'IDoklad API Client'
  s.description = 'A Ruby client for the IDoklad API'
  s.authors     = ['Jan Voňavka']
  s.email       = 'vonavka@iquest.cz'
  s.files       = ['lib/idoklad.rb']
  s.homepage    =
    'https://rubygems.org/gems/idoklad_client'
  s.license = 'MIT'
  s.add_dependency 'oauth2', '~> 2.0'
end
