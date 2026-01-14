# frozen_string_literal: true

require 'oauth2'

# Module for Idoklad API Client
# This module provides a client to interact with the Idoklad API
# It uses OAuth2 for authentication and allows configuration of API URL, client ID, client secret, and logging
# Example usage:
#   Idoklad.configure do |config|
#     config.client_id = 'your_client_id'
#     config.client_secret = 'your_client_secret'
#   end
#
#   client = Idoklad.client
module Idoklad
  class Client
    def initialize(
      url: default_configuration.api_url,
      client_id: default_configuration.client_id,
      client_secret: default_configuration.client_secret,
      logger: default_configuration.logger
    )
      @url_base = url[-1] == '/' ? url : "#{url}/"
      @client_id = client_id
      @client_secret = client_secret
      @logger = logger

      OAuth2::Client.new(@client_id, @client_secret, site: @url_base, logger: @logger)
    end

    def default_configuration
      Idoklad.configuration
    end
  end
end
