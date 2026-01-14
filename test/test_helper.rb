# frozen_string_literal: true

require 'minitest'
require 'dotenv'
require_relative '../lib/idoklad_client/configuration'

module Rails
  def self.root
    dir = File.dirname(__FILE__)
    Pathname.new dir
  end

  def self.env
    :test
  end
end

module TestHelpers
  Dotenv.load('.env.test', '.env')

  def build_client
    IdokladClient.configure do |config|
      config.client_id = ENV['IDOKLAD_CLIENT_ID']
      config.client_secret = ENV['IDOKLAD_CLIENT_SECRET']
      config.application_id = ENV['IDOKLAD_APPLICATION_ID']
    end
    IdokladClient.client
  end
end
