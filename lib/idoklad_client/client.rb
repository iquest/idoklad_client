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

    def request(url, params = {})
      access.get("#{@url_base}/#{url}", params: params).parsed
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

    def patch(url, params)
      access.patch("#{@url_base}/#{url}") do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end.parsed
    end

    def destroy(url, params = nil)
      access.delete("#{@url_base}/#{url}") do |req|
        next unless params

        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end.parsed
    end

    def contacts
      @contacts ||= Endpoints::Contacts.new(self)
    end

    def webhooks
      @webhooks ||= Endpoints::Webhooks.new(self)
    end

    def issued_invoices
      @issued_invoices ||= Endpoints::IssuedInvoices.new(self)
    end

    def proforma_invoices
      @proforma_invoices ||= Endpoints::ProformaInvoices.new(self)
    end

    def received_invoices
      @received_invoices ||= Endpoints::ReceivedInvoices.new(self)
    end

    def credit_notes
      @credit_notes ||= Endpoints::CreditNotes.new(self)
    end

    def sales_receipts
      @sales_receipts ||= Endpoints::SalesReceipts.new(self)
    end

    def bank_accounts
      @bank_accounts ||= Endpoints::BankAccounts.new(self)
    end

    def bank_statements
      @bank_statements ||= Endpoints::BankStatements.new(self)
    end

    def price_list_items
      @price_list_items ||= Endpoints::PriceListItems.new(self)
    end

    def numeric_sequences
      @numeric_sequences ||= Endpoints::NumericSequences.new(self)
    end
  end
end
