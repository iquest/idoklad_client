# frozen_string_literal: true

module IdokladClient
  module Endpoints
    # https://api.idoklad.cz/Help/v3/cs/index.html#api-ReceivedInvoices
    # rubocop:disable Metrics/ClassLength
    class ReceivedInvoices < Base
      CREATE_SCHEMA = {
        'AccountNumber' => { type: :string },
        'BankId' => { type: :integer },
        'CurrencyId' => { type: :integer },
        'DateOfIssue' => { type: :date },
        'DateOfMaturity' => { type: :date, required: true },
        'DateOfPayment' => { type: :date },
        'DateOfReceiving' => { type: :date, required: true },
        'DateOfTaxing' => { type: :date },
        'DateOfVatApplication' => { type: :date },
        'Description' => { type: :string, required: true },
        'DocumentSerialNumber' => { type: :integer, required: true },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'Iban' => { type: :string },
        'InboxId' => { type: :integer },
        'IsIncomeTax' => { type: :boolean, required: true },
        'Items' => { type: :array, required: true, element: { type: :object, schema: {
          'Amount' => { type: :decimal, required: true },
          'CustomVatRate' => { type: :decimal },
          'Name' => { type: :string, required: true },
          'PriceListItemId' => { type: :integer },
          'PriceType' => { type: :enum, required: true, enum: :price_type },
          'Unit' => { type: :string },
          'UnitPrice' => { type: :decimal, required: true },
          'VatCodeId' => { type: :integer },
          'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
        }.freeze } },
        'Note' => { type: :string },
        'OrderNumber' => { type: :string },
        'PartnerId' => { type: :integer, required: true },
        'PaymentOptionId' => { type: :integer, required: true },
        'ReceivedDocumentNumber' => { type: :string },
        'Swift' => { type: :string },
        'Tags' => { type: :array, element: { type: :integer } },
        'VariableSymbol' => { type: :string },
        'VatOnPayStatus' => { type: :enum, enum: :vat_on_pay_status },
        'VatReverseChargeCodeId' => { type: :integer }
      }.freeze

      RECOUNT_SCHEMA = {
        'CurrencyId' => { type: :integer },
        'DateOfReceiving' => { type: :date, required: true },
        'DateOfTaxing' => { type: :date, required: true },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'Items' => { type: :array, required: true, element: { type: :object, schema: {
          'Amount' => { type: :decimal, required: true },
          'CustomVatRate' => { type: :decimal },
          'Id' => { type: :integer },
          'Name' => { type: :string },
          'PriceType' => { type: :enum, required: true, enum: :price_type },
          'UnitPrice' => { type: :decimal, required: true },
          'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
        }.freeze } }
      }.freeze

      UPDATE_SCHEMA = {
        'AccountNumber' => { type: :string },
        'BankId' => { type: :integer },
        'CurrencyId' => { type: :integer },
        'DateOfIssue' => { type: :date },
        'DateOfMaturity' => { type: :date },
        'DateOfPayment' => { type: :date },
        'DateOfReceiving' => { type: :date },
        'DateOfTaxing' => { type: :date },
        'DateOfVatApplication' => { type: :date },
        'Description' => { type: :string },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'Iban' => { type: :string },
        'Id' => { type: :integer },
        'IsIncomeTax' => { type: :boolean },
        'Items' => { type: :array, element: { type: :object, schema: {
          'Amount' => { type: :decimal },
          'CustomVatRate' => { type: :decimal },
          'Id' => { type: :integer },
          'Name' => { type: :string, required: true },
          'PriceType' => { type: :enum, enum: :price_type },
          'Unit' => { type: :string },
          'UnitPrice' => { type: :decimal },
          'VatCodeId' => { type: :integer },
          'VatRateType' => { type: :enum, enum: :vat_rate_type }
        }.freeze } },
        'Note' => { type: :string },
        'OrderNumber' => { type: :string },
        'PartnerId' => { type: :integer },
        'PaymentOptionId' => { type: :integer },
        'ReceivedDocumentNumber' => { type: :string },
        'Swift' => { type: :string },
        'Tags' => { type: :array, element: { type: :integer } },
        'VariableSymbol' => { type: :string },
        'VatOnPayStatus' => { type: :enum, enum: :vat_on_pay_status },
        'VatReverseChargeCodeId' => { type: :integer }
      }.freeze

      # GET /ReceivedInvoices/{id}
      def detail(id, include: nil)
        check_integer!(id, 'id')
        query = {}
        query[:Include] = check_string!(include, 'include') if include
        client.request("ReceivedInvoices/#{id}", query)
      end

      # GET /ReceivedInvoices/{id}/Copy
      def copy(id)
        check_integer!(id, 'id')
        client.request("ReceivedInvoices/#{id}/Copy")
      end

      # GET /ReceivedInvoices
      def list(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        client.request('ReceivedInvoices',
                       list_query(filter: filter, filtertype: filtertype, sort: sort, page: page, pagesize: pagesize))
      end

      # GET /ReceivedInvoices/Default
      def default(inbox_id:)
        check_integer!(inbox_id, 'inbox_id')
        client.request('ReceivedInvoices/Default', inboxId: inbox_id)
      end

      # POST /ReceivedInvoices
      def create(params)
        params = validate!(params, CREATE_SCHEMA)
        client.create('ReceivedInvoices', params)
      end

      # POST /ReceivedInvoices/Recount
      def recount(params)
        params = validate!(params, RECOUNT_SCHEMA)
        client.create('ReceivedInvoices/Recount', params)
      end

      # PATCH /ReceivedInvoices
      def update(params)
        params = validate!(params, UPDATE_SCHEMA)
        client.patch('ReceivedInvoices', params)
      end

      # DELETE /ReceivedInvoices/{id}
      def delete(id)
        check_integer!(id, 'id')
        client.destroy("ReceivedInvoices/#{id}")
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
