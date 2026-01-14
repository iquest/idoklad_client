# idoklad_client

Ruby client for the iDoklad REST API v3. Official API reference: https://api.idoklad.cz/Help/v3/cs/index.html

This gem provides a minimal OAuth2-enabled client to call iDoklad endpoints. It supports API v3 by default (and v2 via `IDOKLAD_VERSION=2`) and focuses on simplicity: configure credentials, obtain an app token, and perform GET requests against the iDoklad API.

## Features

- **API v3 support:** Uses `https://api.idoklad.cz/v3` by default.
- **OAuth2 client credentials:** Retrieves an application token from `identity.idoklad.cz` with `scope=idoklad_api` and `application_id`.
- **Simple requests:** Convenience `request(path)` for HTTP GET returning parsed JSON.
- **Config via code or ENV:** `IDOKLAD_CLIENT_ID`, `IDOKLAD_CLIENT_SECRET`, `IDOKLAD_APPLICATION_ID`, `IDOKLAD_VERSION`.

## Installation

Add to your Gemfile:

```ruby
gem 'idoklad_client'
```

Then:

```bash
bundle install
```

Or add to bundle directly:

```bash
bundle add idoklad_client
```

Or install directly:

```bash
gem install idoklad_client
```

## Configuration

Configure programmatically:

```ruby
require 'idoklad_client'

IdokladClient.configure do |config|
  config.client_id      = ENV.fetch('IDOKLAD_CLIENT_ID')
  config.client_secret  = ENV.fetch('IDOKLAD_CLIENT_SECRET')
  config.application_id = ENV.fetch('IDOKLAD_APPLICATION_ID')
  # Optional: config.logger = -> { Logger.new($stdout) }
end

client = IdokladClient.client
```

Or via environment variables (recommended for production):

- `IDOKLAD_CLIENT_ID`: OAuth2 Client ID
- `IDOKLAD_CLIENT_SECRET`: OAuth2 Client Secret
- `IDOKLAD_APPLICATION_ID`: iDoklad Application ID
- `IDOKLAD_VERSION`: `3` (default) or `2`

## Authentication

The client uses the OAuth2 Client Credentials flow against `https://identity.idoklad.cz/server/v2/connect/token` with `scope=idoklad_api`. The `application_id` must be provided. See the official documentation for details and requirements.

```ruby
token = IdokladClient.client.access # => OAuth2::AccessToken
token.token # => "eyJ..."
```

## Usage

Calls are performed with relative paths resolved against the configured base (`https://api.idoklad.cz/v3`). The `request(path)` method performs a GET and returns parsed JSON.

Examples:

```ruby
client = IdokladClient.client

# List resources (replace with an actual endpoint from the docs):
contacts = client.request('Contacts')
```

Refer to the official API v3 reference for the exact endpoint paths, parameters for paging (`Page`, `PageSize`), sorting (`OrderBy`), and filtering. This client is intentionally thin and does not wrap specific endpoints.

## Logging

You can provide a lambda that returns a logger to inspect OAuth2 traffic when debugging:

```ruby
IdokladClient.configure do |config|
  config.logger = -> { Logger.new($stdout) }
end
```

## Development

This library is minimal by design. If you need POST/PUT/PATCH helpers or typed models, contributions are welcome.

## Contributing

Bug reports and pull requests are welcome. Please ensure any examples and links remain consistent with iDoklad API v3.

## License

MIT License.