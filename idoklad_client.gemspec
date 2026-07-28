Gem::Specification.new do |s|
  s.name        = 'idoklad_client'
  s.version     = '0.0.1'
  s.summary     = 'IDoklad API Client'
  s.description = 'A Ruby client for the IDoklad API'
  s.authors     = ['Jan Voňavka']
  s.email       = 'vonavka@iquest.cz'
  s.homepage    = 'https://github.com/iquest/idoklad_client'
  s.files       = ['lib/idoklad_client/client.rb',
                   'lib/idoklad_client/constants.rb',
                   'lib/idoklad_client/configuration.rb',
                   'lib/idoklad_client.rb']
  s.license = 'MIT'
  s.add_dependency 'oauth2', '~> 2.0'
end
