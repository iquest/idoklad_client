# frozen_string_literal: true

module IdokladClient
  module Endpoints
    # https://api.idoklad.cz/Help/v3/cs/index.html#api-IssuedInvoices
    # rubocop:disable Metrics/ClassLength
    class IssuedInvoices < Base
      CREATE_SCHEMA = {
        'AccountNumber' => { type: :string },
        'BankId' => { type: :integer },
        'ConstantSymbolId' => { type: :integer },
        'CurrencyId' => { type: :integer, required: true },
        'DateOfIssue' => { type: :date, required: true },
        'DateOfMaturity' => { type: :date, required: true },
        'DateOfPayment' => { type: :date },
        'DateOfTaxing' => { type: :date, required: true },
        'DateOfVatApplication' => { type: :date },
        'DeliveryAddressId' => { type: :integer },
        'Description' => { type: :string, required: true },
        'DiscountPercentage' => { type: :decimal },
        'DocumentSerialNumber' => { type: :integer, required: true },
        'EetResponsibility' => { type: :enum, enum: :eet_responsibility },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'HasVatRegimeOss' => { type: :boolean },
        'Iban' => { type: :string },
        'IsEet' => { type: :boolean, required: true },
        'IsIncomeTax' => { type: :boolean, required: true },
        'Items' => { type: :array, required: true, element: { type: :object, schema: {
          'Amount' => { type: :decimal, required: true },
          'Code' => { type: :string },
          'DiscountName' => { type: :string },
          'DiscountPercentage' => { type: :decimal, required: true },
          'InvoiceProformaId' => { type: :integer },
          'IsTaxMovement' => { type: :boolean, required: true },
          'ItemType' => { type: :enum, enum: :item_type },
          'Name' => { type: :string, required: true },
          'PriceListItemId' => { type: :integer },
          'PriceType' => { type: :enum, required: true, enum: :price_type },
          'Unit' => { type: :string },
          'UnitPrice' => { type: :decimal, required: true },
          'VatCodeId' => { type: :integer },
          'VatRate' => { type: :decimal },
          'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
        }.freeze } },
        'ItemsTextPrefix' => { type: :string },
        'ItemsTextSuffix' => { type: :string },
        'Note' => { type: :string },
        'NumericSequenceId' => { type: :integer, required: true },
        'OrderNumber' => { type: :string },
        'PartnerId' => { type: :integer, required: true },
        'PaymentOptionId' => { type: :integer, required: true },
        'ProformaInvoices' => { type: :array, element: { type: :integer } },
        'ReportLanguage' => { type: :enum, enum: :report_language },
        'SalesOrderId' => { type: :integer },
        'SalesPosEquipmentId' => { type: :integer },
        'Swift' => { type: :string },
        'Tags' => { type: :array, element: { type: :integer } },
        'VariableSymbol' => { type: :string },
        'VatOnPayStatus' => { type: :enum, enum: :vat_on_pay_status },
        'VatReverseChargeCodeId' => { type: :integer }
      }.freeze

      RECOUNT_SCHEMA = {
        'CurrencyId' => { type: :integer },
        'DateOfTaxing' => { type: :date, required: true },
        'DiscountPercentage' => { type: :decimal },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'HasVatRegimeOss' => { type: :boolean },
        'Items' => { type: :array, required: true, element: { type: :object, schema: {
          'Amount' => { type: :decimal, required: true },
          'DiscountPercentage' => { type: :decimal, required: true },
          'Id' => { type: :integer },
          'IsTaxMovement' => { type: :boolean },
          'ItemType' => { type: :enum, enum: :item_type },
          'Name' => { type: :string },
          'PriceType' => { type: :enum, required: true, enum: :price_type },
          'UnitPrice' => { type: :decimal, required: true },
          'VatRate' => { type: :decimal },
          'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
        }.freeze } },
        'PaymentOptionId' => { type: :integer },
        'VatRateCountryId' => { type: :integer },
        'VatRatePeriods' => { type: :array, element: { type: :date } }
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
        'DiscountPercentage' => { type: :decimal },
        'EetResponsibility' => { type: :enum, enum: :eet_responsibility },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'Id' => { type: :integer, required: true },
        'IsEet' => { type: :boolean },
        'IsIncomeTax' => { type: :boolean },
        'Items' => { type: :array, element: { type: :object, schema: {
          'Amount' => { type: :decimal },
          'Code' => { type: :string },
          'DiscountName' => { type: :string },
          'DiscountPercentage' => { type: :decimal },
          'Id' => { type: :integer },
          'IsTaxMovement' => { type: :boolean },
          'Name' => { type: :string },
          'PriceListItemId' => { type: :integer },
          'PriceType' => { type: :enum, enum: :price_type },
          'Unit' => { type: :string },
          'UnitPrice' => { type: :decimal },
          'VatCodeId' => { type: :integer },
          'VatRate' => { type: :decimal },
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

      # GET /IssuedInvoices/{id}
      def detail(id, include: nil)
        check_integer!(id, 'id')
        query = {}
        query[:Include] = check_string!(include, 'include') if include
        client.request("IssuedInvoices/#{id}", query)
      end

      # GET /IssuedInvoices/{id}/Copy
      def copy(id)
        check_integer!(id, 'id')
        client.request("IssuedInvoices/#{id}/Copy")
      end

      # GET /IssuedInvoices/{id}/Recurrence
      def recurrence(id)
        check_integer!(id, 'id')
        client.request("IssuedInvoices/#{id}/Recurrence")
      end

      # GET /IssuedInvoices
      def list(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        client.request('IssuedInvoices',
                       list_query(filter: filter, filtertype: filtertype, sort: sort, page: page, pagesize: pagesize))
      end

      # GET /IssuedInvoices/Default
      def default
        client.request('IssuedInvoices/Default')
      end

      # POST /IssuedInvoices
      def create(params)
        params = validate!(params, CREATE_SCHEMA)
        client.create('IssuedInvoices', params)
      end

      # POST /IssuedInvoices/Recount
      def recount(params)
        params = validate!(params, RECOUNT_SCHEMA)
        client.create('IssuedInvoices/Recount', params)
      end

      # PATCH /IssuedInvoices (Id is part of params)
      def update(params)
        params = validate!(params, UPDATE_SCHEMA)
        client.patch('IssuedInvoices', params)
      end

      # DELETE /IssuedInvoices/{id}
      def delete(id)
        check_integer!(id, 'id')
        client.destroy("IssuedInvoices/#{id}")
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
