# frozen_string_literal: true

module IdokladClient
  module Endpoints
    # https://api.idoklad.cz/Help/v3/cs/index.html#api-Contacts
    class Contacts < Base
      CREATE_SCHEMA = {
        'AccountNumber' => { type: :string },
        'BankId' => { type: :integer },
        'City' => { type: :string },
        'CompanyName' => { type: :string, required: true },
        'CountryId' => { type: :integer },
        'DefaultInvoiceMaturity' => { type: :integer },
        'DeliveryAddresses' => { type: :array, element: { type: :object, schema: {
          'City' => { type: :string },
          'IsDefault' => { type: :boolean },
          'Name' => { type: :string, required: true },
          'PostalCode' => { type: :string },
          'Street' => { type: :string }
        }.freeze } },
        'DiscountPercentage' => { type: :decimal },
        'Email' => { type: :string },
        'Fax' => { type: :string },
        'Firstname' => { type: :string },
        'Iban' => { type: :string },
        'IdentificationNumber' => { type: :string },
        'IsRegisteredForVatOnPay' => { type: :boolean },
        'Mobile' => { type: :string },
        'Note' => { type: :string },
        'Phone' => { type: :string },
        'PostalCode' => { type: :string },
        'SendReminders' => { type: :boolean },
        'Street' => { type: :string },
        'Surname' => { type: :string },
        'Swift' => { type: :string },
        'Title' => { type: :string },
        'VatIdentificationNumber' => { type: :string },
        'VatIdentificationNumberSk' => { type: :string },
        'Www' => { type: :string }
      }.freeze

      UPDATE_SCHEMA = {
        'AccountNumber' => { type: :string },
        'BankId' => { type: :integer },
        'City' => { type: :string },
        'CompanyName' => { type: :string },
        'CountryId' => { type: :integer },
        'DefaultInvoiceMaturity' => { type: :integer },
        'DeliveryAddresses' => { type: :array, element: { type: :object, schema: {
          'City' => { type: :string },
          'Id' => { type: :integer },
          'IsDefault' => { type: :boolean },
          'Name' => { type: :string, required: true },
          'PostalCode' => { type: :string },
          'Street' => { type: :string }
        }.freeze } },
        'DiscountPercentage' => { type: :decimal },
        'Email' => { type: :string },
        'Fax' => { type: :string },
        'Firstname' => { type: :string },
        'Iban' => { type: :string },
        'Id' => { type: :integer, required: true },
        'IdentificationNumber' => { type: :string },
        'IsRegisteredForVatOnPay' => { type: :boolean },
        'Mobile' => { type: :string },
        'Note' => { type: :string },
        'Phone' => { type: :string },
        'PostalCode' => { type: :string },
        'SendReminders' => { type: :boolean },
        'Street' => { type: :string },
        'Surname' => { type: :string },
        'Swift' => { type: :string },
        'Title' => { type: :string },
        'VatIdentificationNumber' => { type: :string },
        'VatIdentificationNumberSk' => { type: :string },
        'Www' => { type: :string }
      }.freeze

      # GET /Contacts/{id}
      def detail(id, include: nil)
        check_integer!(id, 'id')
        query = {}
        query[:Include] = check_string!(include, 'include') if include
        client.request("Contacts/#{id}", query)
      end

      # GET /Contacts
      def list(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        client.request('Contacts',
                       list_query(filter: filter, filtertype: filtertype, sort: sort, page: page, pagesize: pagesize))
      end

      # GET /Contacts/Default
      def default
        client.request('Contacts/Default')
      end

      # POST /Contacts
      def create(params)
        params = validate!(params, CREATE_SCHEMA)
        client.create('Contacts', params)
      end

      # PATCH /Contacts (Id is part of params)
      def update(params)
        params = validate!(params, UPDATE_SCHEMA)
        client.patch('Contacts', params)
      end

      # DELETE /Contacts/{id}
      def delete(id)
        check_integer!(id, 'id')
        client.destroy("Contacts/#{id}")
      end
    end
  end
end
