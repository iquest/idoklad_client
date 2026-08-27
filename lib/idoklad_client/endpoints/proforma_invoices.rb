# frozen_string_literal: true

module IdokladClient
  module Endpoints
    # https://api.idoklad.cz/Help/v3/cs/index.html#api-ProformaInvoices
    # rubocop:disable Metrics/ClassLength
    class ProformaInvoices < Base
      CREATE_SCHEMA = {
        'AccountNumber' => { type: :string },
        'BankId' => { type: :integer },
        'ConstantSymbolId' => { type: :integer },
        'CurrencyId' => { type: :integer, required: true },
        'DateOfIssue' => { type: :date, required: true },
        'DateOfMaturity' => { type: :date, required: true },
        'DateOfPayment' => { type: :date },
        'DateOfTaxing' => { type: :date },
        'DateOfVatApplication' => { type: :date },
        'DeliveryAddressId' => { type: :integer },
        'Description' => { type: :string, required: true },
        'DocumentSerialNumber' => { type: :integer, required: true },
        'EetResponsibility' => { type: :enum, enum: :eet_responsibility },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'Exported' => { type: :enum, enum: :exported },
        'Iban' => { type: :string },
        'IsEet' => { type: :boolean, required: true },
        'IsIncomeTax' => { type: :boolean, required: true },
        'Items' => { type: :array, element: { type: :object, schema: {
          'Amount' => { type: :decimal, required: true },
          'Code' => { type: :string },
          'IsTaxMovement' => { type: :boolean, required: true },
          'Name' => { type: :string, required: true },
          'PriceListItemId' => { type: :integer },
          'PriceType' => { type: :enum, required: true, enum: :price_type },
          'Unit' => { type: :string },
          'UnitPrice' => { type: :decimal, required: true },
          'VatCodeId' => { type: :integer },
          'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
        }.freeze } },
        'ItemsTextPrefix' => { type: :string },
        'ItemsTextSuffix' => { type: :string },
        'Note' => { type: :string },
        'NumericSequenceId' => { type: :integer, required: true },
        'OrderNumber' => { type: :string },
        'PartnerId' => { type: :integer, required: true },
        'PaymentOptionId' => { type: :integer, required: true },
        'ReportLanguage' => { type: :enum, enum: :report_language },
        'SalesOrderId' => { type: :integer },
        'SalesPosEquipmentId' => { type: :integer },
        'Swift' => { type: :string },
        'Tags' => { type: :array, element: { type: :integer } },
        'VariableSymbol' => { type: :string },
        'VatOnPayStatus' => { type: :enum, enum: :vat_on_pay_status }
      }.freeze

      RECOUNT_SCHEMA = {
        'CurrencyId' => { type: :integer },
        'DateOfTaxing' => { type: :date, required: true },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'Items' => { type: :array, required: true, element: { type: :object, schema: {
          'Amount' => { type: :decimal, required: true },
          'Id' => { type: :integer },
          'Name' => { type: :string },
          'PriceType' => { type: :enum, required: true, enum: :price_type },
          'UnitPrice' => { type: :decimal, required: true },
          'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
        }.freeze } },
        'PaymentOptionId' => { type: :integer }
      }.freeze

      ACCOUNT_MULTIPLE_SCHEMA = {
        'ProformaIds' => { type: :array, required: true, element: { type: :integer } }
      }.freeze

      UPDATE_SCHEMA = {
        'ConstantSymbolId' => { type: :integer },
        'CurrencyId' => { type: :integer },
        'DateOfIssue' => { type: :date },
        'DateOfMaturity' => { type: :date },
        'DateOfPayment' => { type: :date },
        'DateOfTaxing' => { type: :date },
        'DateOfVatApplication' => { type: :date },
        'DeliveryAddressId' => { type: :integer },
        'Description' => { type: :string },
        'EetResponsibility' => { type: :enum, enum: :eet_responsibility },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'Id' => { type: :integer, required: true },
        'IsEet' => { type: :boolean },
        'IsIncomeTax' => { type: :boolean },
        'Items' => { type: :array, element: { type: :object, schema: {
          'Amount' => { type: :decimal },
          'Code' => { type: :string },
          'Id' => { type: :integer },
          'Name' => { type: :string },
          'PriceType' => { type: :enum, enum: :price_type },
          'Unit' => { type: :string },
          'UnitPrice' => { type: :decimal },
          'VatCodeId' => { type: :integer },
          'VatRateType' => { type: :enum, enum: :vat_rate_type }
        }.freeze } },
        'ItemsTextPrefix' => { type: :string },
        'ItemsTextSuffix' => { type: :string },
        'MyAddress' => { type: :object, schema: {
          'AccountNumber' => { type: :string },
          'BankId' => { type: :integer },
          'Iban' => { type: :string },
          'Swift' => { type: :string }
        }.freeze },
        'Note' => { type: :string },
        'OrderNumber' => { type: :string },
        'PartnerAddress' => { type: :object, schema: {
          'AccountNumber' => { type: :string },
          'BankId' => { type: :integer },
          'City' => { type: :string },
          'CompanyName' => { type: :string },
          'CountryId' => { type: :integer },
          'Fax' => { type: :string },
          'Firstname' => { type: :string },
          'Iban' => { type: :string },
          'IdentificationNumber' => { type: :string },
          'Mobile' => { type: :string },
          'Phone' => { type: :string },
          'PostalCode' => { type: :string },
          'Street' => { type: :string },
          'Surname' => { type: :string },
          'Swift' => { type: :string },
          'Title' => { type: :string },
          'VatIdentificationNumber' => { type: :string },
          'VatIdentificationNumberSk' => { type: :string },
          'Www' => { type: :string }
        }.freeze },
        'PartnerId' => { type: :integer },
        'PaymentOptionId' => { type: :integer },
        'ReportLanguage' => { type: :enum, enum: :report_language },
        'Tags' => { type: :array, element: { type: :integer } },
        'VariableSymbol' => { type: :string },
        'VatOnPayStatus' => { type: :enum, enum: :vat_on_pay_status },
        'VatReverseChargeCodeId' => { type: :integer }
      }.freeze

      # GET /ProformaInvoices/{id}
      def detail(id, include: nil)
        check_integer!(id, 'id')
        query = {}
        query[:Include] = check_string!(include, 'include') if include
        client.request("ProformaInvoices/#{id}", query)
      end

      # GET /ProformaInvoices/{id}/Copy
      def copy(id)
        check_integer!(id, 'id')
        client.request("ProformaInvoices/#{id}/Copy")
      end

      # GET /ProformaInvoices/{id}/Recurrence
      def recurrence(id)
        check_integer!(id, 'id')
        client.request("ProformaInvoices/#{id}/Recurrence")
      end

      # GET /ProformaInvoices/{id}/Account
      def invoice_for_accounting(id, date_for_accounting:)
        check_integer!(id, 'id')
        check_date!(date_for_accounting, 'date_for_accounting')
        client.request("ProformaInvoices/#{id}/Account", dateForAccounting: date_for_accounting)
      end

      # GET /ProformaInvoices
      def list(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        client.request('ProformaInvoices',
                       list_query(filter: filter, filtertype: filtertype, sort: sort, page: page, pagesize: pagesize))
      end

      # GET /ProformaInvoices/Default
      def default(template_id:)
        check_integer!(template_id, 'template_id')
        client.request('ProformaInvoices/Default', templateId: template_id)
      end

      # POST /ProformaInvoices
      def create(params)
        params = validate!(params, CREATE_SCHEMA)
        client.create('ProformaInvoices', params)
      end

      # POST /ProformaInvoices/Recount
      def recount(params)
        params = validate!(params, RECOUNT_SCHEMA)
        client.create('ProformaInvoices/Recount', params)
      end

      # PUT /ProformaInvoices/Account - account for (vyúčtovat) multiple proforma invoices at once
      def account_multiple(params)
        params = validate!(params, ACCOUNT_MULTIPLE_SCHEMA)
        client.update('ProformaInvoices/Account', params)
      end

      # PUT /ProformaInvoices/{id}/Account - account for (vyúčtovat) a single proforma invoice
      def account(id)
        check_integer!(id, 'id')
        client.update("ProformaInvoices/#{id}/Account", {})
      end

      # PATCH /ProformaInvoices (Id is part of params)
      def update(params)
        params = validate!(params, UPDATE_SCHEMA)
        client.patch('ProformaInvoices', params)
      end

      # DELETE /ProformaInvoices/{id}
      def delete(id)
        check_integer!(id, 'id')
        client.destroy("ProformaInvoices/#{id}")
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
