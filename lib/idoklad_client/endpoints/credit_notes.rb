# frozen_string_literal: true

module IdokladClient
  module Endpoints
    # https://api.idoklad.cz/Help/v3/cs/index.html#api-CreditNotes
    # rubocop:disable Metrics/ClassLength
    class CreditNotes < Base
      # Shared by POST /CreditNotes and POST /CreditNotes/Offset - both create a credit note
      # with the same body, the latter additionally offsets it against the credited invoice.
      CREATE_SCHEMA = {
        'AccountNumber' => { type: :string },
        'BankId' => { type: :integer },
        'ConstantSymbolId' => { type: :integer },
        'CreditedInvoiceId' => { type: :integer, required: true },
        'CreditNoteReason' => { type: :string, required: true },
        'CurrencyId' => { type: :integer, required: true },
        'DateOfIssue' => { type: :date, required: true },
        'DateOfMaturity' => { type: :date, required: true },
        'DateOfPayment' => { type: :date },
        'DateOfTaxing' => { type: :date, required: true },
        'DateOfVatApplication' => { type: :date },
        'DateOfVatClaim' => { type: :date },
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
          'IsTaxMovement' => { type: :boolean, required: true },
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
        'NoteForCreditNote' => { type: :string },
        'NumericSequenceId' => { type: :integer, required: true },
        'OrderNumber' => { type: :string },
        'PartnerId' => { type: :integer, required: true },
        'PaymentOptionId' => { type: :integer, required: true },
        'ReportLanguage' => { type: :enum, enum: :report_language },
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
          'ItemType' => { type: :enum, enum: :item_type },
          'Name' => { type: :string },
          'PriceType' => { type: :enum, required: true, enum: :price_type },
          'UnitPrice' => { type: :decimal, required: true },
          'VatRate' => { type: :decimal },
          'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
        }.freeze } },
        'PaymentOptionId' => { type: :integer, required: true },
        'VatRateCountryId' => { type: :integer },
        'VatRatePeriods' => { type: :array, element: { type: :date } }
      }.freeze

      OFFSET_SCHEMA = {
        'DateOfPayment' => { type: :date }
      }.freeze

      UPDATE_SCHEMA = {
        'ConstantSymbolId' => { type: :integer },
        'CreditNoteReason' => { type: :string },
        'CurrencyId' => { type: :integer },
        'DateOfIssue' => { type: :date },
        'DateOfMaturity' => { type: :date },
        'DateOfPayment' => { type: :date },
        'DateOfTaxing' => { type: :date },
        'DateOfVatApplication' => { type: :date },
        'DateOfVatClaim' => { type: :date },
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
        'NoteForCreditNote' => { type: :string },
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

      # GET /CreditNotes/{id}
      def detail(id, include: nil)
        check_integer!(id, 'id')
        query = {}
        query[:Include] = check_string!(include, 'include') if include
        client.request("CreditNotes/#{id}", query)
      end

      # GET /CreditNotes
      def list(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        client.request('CreditNotes',
                       list_query(filter: filter, filtertype: filtertype, sort: sort, page: page, pagesize: pagesize))
      end

      # GET /CreditNotes/Default/{invoiceId}
      def default_for_invoice(invoice_id)
        check_integer!(invoice_id, 'invoice_id')
        client.request("CreditNotes/Default/#{invoice_id}")
      end

      # POST /CreditNotes
      def create(params)
        params = validate!(params, CREATE_SCHEMA)
        client.create('CreditNotes', params)
      end

      # POST /CreditNotes/Offset - create a credit note and immediately offset it against the credited invoice
      def create_with_offset(params)
        params = validate!(params, CREATE_SCHEMA)
        client.create('CreditNotes/Offset', params)
      end

      # POST /CreditNotes/Recount
      def recount(params)
        params = validate!(params, RECOUNT_SCHEMA)
        client.create('CreditNotes/Recount', params)
      end

      # PUT /CreditNotes/{id}/Offset - offset an existing credit note against its credited invoice
      def offset(id, params = {})
        check_integer!(id, 'id')
        params = validate!(params, OFFSET_SCHEMA)
        client.update("CreditNotes/#{id}/Offset", params)
      end

      # PATCH /CreditNotes (Id is part of params)
      def update(params)
        params = validate!(params, UPDATE_SCHEMA)
        client.patch('CreditNotes', params)
      end

      # DELETE /CreditNotes/{id}
      def delete(id)
        check_integer!(id, 'id')
        client.destroy("CreditNotes/#{id}")
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
