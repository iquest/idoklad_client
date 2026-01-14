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
  class Client < OAuth2::Client
    def initialize(
      api_url: default_configuration.api_url,
      auth_url: default_configuration.auth_url,
      client_id: default_configuration.client_id,
      client_secret: default_configuration.client_secret,
      logger: default_configuration.logger
    )
      @url_base = api_url[-1] == '/' ? api_url : "#{api_url}/"
      @auth_base_url = auth_url[-1] == '/' ? auth_url : "#{auth_url}/"
      @client_id = client_id
      @client_secret = client_secret
      @logger = logger
      super(@client_id, @client_secret, site: @auth_base_url, logger: @logger)
    end

    def default_configuration
      IdokladClient.configuration
    end
  end
end
