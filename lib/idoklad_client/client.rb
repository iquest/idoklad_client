# frozen_string_literal: true

require 'oauth2'

# Module for IdokladClient API Client
# This module provides a client to interact with the iDoklad API
# It uses OAuth2 for authentication and allows configuration of client ID, client secret, and logging
# Example usage:
#   IdokladClient.configure do |config|
#     config.client_id = 'your_client_id'
#     config.client_secret = 'your_client_secret'
#   end
#
#   client = Idoklad.client
module IdokladClient
  # This class is used for creating the client
  class Client
    def initialize(
      api_url: default_configuration.api_url,
      auth_url: default_configuration.auth_url,
      client_id: default_configuration.client_id,
      client_secret: default_configuration.client_secret,
      application_id: default_configuration.application_id,
      logger: default_configuration.logger
    )
      @url_base = api_url[-1] == '/' ? api_url.chomp('/') : api_url
      @auth_base_url = auth_url[-1] == '/' ? auth_url.chomp('/') : auth_url
      @client_id = client_id
      @client_secret = client_secret
      @application_id = application_id
      @logger = logger
    end

    # returns OAuth2::AccessToken
    def access
      client = OAuth2::Client.new(
        @client_id,
        @client_secret,
        site: @auth_base_url,
        logger: @logger,
        token_url: '/server/v2/connect/token'
      )
      client.client_credentials.get_token(application_id: @application_id,
                                          scope: 'idoklad_api')
    end

    def default_configuration
      IdokladClient.configuration
    end

    def request(url)
      access.get("#{@url_base}/#{url}").parsed
    end

    def create(url, params)
      access.post("#{@url_base}/#{url}") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end.parsed
    end

    def update(url, params)
      access.put("#{@url_base}/#{url}") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end.parsed
    end
  end
end
