# frozen_string_literal: true

require 'minitest'
require 'byebug'
require 'openssl'
require 'pathname'
require 'dotenv'
require_relative '../lib/../lib/idoklad/configuration'

module Rails
  def self.root
    dir = File.dirname(__FILE__)
    Pathname.new dir
  end

  def self.env
    :test
  end
end

module CsobPaymentGateway
  Dotenv.load('.env.test', '.env')

  def self.symbolize_keys(hsh)
    hsh.transform_keys(&:to_sym)
  end


  def create_client
    Idoklad.configure do |config|
      config.client_id = ENV.fetch('IDOKLAD_CLIENT_ID', nil)
      config.client_secret = ENV.fetch('IDOKLAD_CLIENT_SECRET', nil)
      # config.logger = -> { Logger.new(STDOUT) }
    end
    Idoklad.client
  end
end
