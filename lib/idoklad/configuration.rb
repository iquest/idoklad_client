# frozen_string_literal: true

require_relative 'client'

# Module for Idoklad
# This module is used to configure the Idoklad
# It provides methods to set the configuration and create a client
# The client is used to interact with the Idoklad API
# The configuration is loaded from environment variables or set to default values
# The configuration can be overridden by calling the configure method
module Idoklad
  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new(
        api_url: api_url,
        client_id: ENV.fetch('IDOKLAD_CLIENT_ID', ''),
        client_secret: ENV.fetch('IDOKLAD_CLIENT_SECRET', ''),
        logger: nil
      )
    end

    def client(**args)
      @client ||= Client.new(**args)
    end

    # rubocop:disable Metrics/MethodLength
    def api_url
      version = (ENV['IDOKLAD_VERSION'] || '3').to_s

      base_url = 'https://api.idoklad.cz'
      base_url += case version.to_s
                  when '2'
                    '/v2'
                  when '3'
                    '/v3'
                  else
                    raise 'Unsupported API version'
                  end
      base_url
    end
    # rubocop:enable Metrics/MethodLength
  end

  # Configuration class for CsobPaymentGateway
  # This class is used to store the configuration for the CsobPaymentGateway
  class Configuration
    attr_accessor :api_url, :client_id, :client_secret

    attr_reader :logger

    def logger=(lambda)
      raise ArgumentError, 'The logger must be a lambda' unless lambda.is_a?(Proc)

      @logger = lambda
    end

    def initialize(hash = {})
      @api_url = hash[:api_url]
      @client_id = hash[:client_id]
      @client_secret = hash[:client_secret]
      @logger = hash[:logger]
    end
  end
end
