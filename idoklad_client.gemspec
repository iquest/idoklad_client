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
                   'lib/idoklad_client/enums.rb',
                   'lib/idoklad_client/schema.rb',
                   'lib/idoklad_client/case_converter.rb',
                   'lib/idoklad_client/endpoints/base.rb',
                   'lib/idoklad_client/endpoints/contacts.rb',
                   'lib/idoklad_client/endpoints/webhooks.rb',
                   'lib/idoklad_client/endpoints/issued_invoices.rb',
                   'lib/idoklad_client/endpoints/proforma_invoices.rb',
                   'lib/idoklad_client/endpoints/received_invoices.rb',
                   'lib/idoklad_client/endpoints/credit_notes.rb',
                   'lib/idoklad_client/endpoints/sales_receipts.rb',
                   'lib/idoklad_client/endpoints/bank_accounts.rb',
                   'lib/idoklad_client/endpoints/bank_statements.rb',
                   'lib/idoklad_client/endpoints/price_list_items.rb',
                   'lib/idoklad_client/endpoints/numeric_sequences.rb',
                   'lib/idoklad_client.rb']
  s.license = 'MIT'
  s.add_dependency 'oauth2', '~> 2.0'
end
