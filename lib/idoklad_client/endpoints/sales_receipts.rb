# frozen_string_literal: true

module IdokladClient
  module Endpoints
    # https://api.idoklad.cz/Help/v3/cs/index.html#api-SalesReceipts
    # rubocop:disable Metrics/ClassLength
    class SalesReceipts < Base
      # Shape of a single sales receipt, shared by POST /SalesReceipts and, wrapped in an
      # Items array, by POST /SalesReceipts/Batch.
      RECEIPT_SCHEMA = {
        'CurrencyId' => { type: :integer },
        'DateOfIssue' => { type: :date, required: true },
        'DocumentSerialNumber' => { type: :integer, required: true },
        'EKasa' => { type: :object, schema: {
          'IsRegistered' => { type: :boolean }
        }.freeze },
        'ElectronicRecordsOfSales' => { type: :object, schema: {
          'EetResponsibility' => { type: :enum, required: true, enum: :eet_responsibility },
          'EetStatus' => { type: :enum, enum: :eet_status },
          'IsEet' => { type: :boolean, required: true },
          'RegisteredSale' => { type: :object, schema: {
            'Bkp' => { type: :string, required: true },
            'DateOfAnswer' => { type: :date, required: true },
            'DateOfSale' => { type: :date, required: true },
            'DateOfSend' => { type: :date, required: true },
            'Fik' => { type: :string, required: true },
            'Pkp' => { type: :string, required: true },
            'Prices' => { type: :object, required: true, schema: {
              'BaseTaxBasicRateHc' => { type: :decimal, required: true },
              'BaseTaxReducedRate1Hc' => { type: :decimal, required: true },
              'BaseTaxReducedRate2Hc' => { type: :decimal, required: true },
              'BaseTaxZeroRateHc' => { type: :decimal, required: true },
              'TaxBasicRateHc' => { type: :decimal, required: true },
              'TaxReducedRate1Hc' => { type: :decimal, required: true },
              'TaxReducedRate2Hc' => { type: :decimal, required: true },
              'TotalAdvancePayment' => { type: :decimal, required: true },
              'TotalFromAdvancePayment' => { type: :decimal, required: true },
              'TotalTravelServiceHc' => { type: :decimal, required: true },
              'TotalUsedGoodsBasicRateHc' => { type: :decimal, required: true },
              'TotalUsedGoodsReducedRate1Hc' => { type: :decimal, required: true },
              'TotalUsedGoodsReducedRate2Hc' => { type: :decimal, required: true },
              'TotalWithVatHc' => { type: :decimal, required: true }
            }.freeze },
            'ReceiptNumber' => { type: :string, required: true },
            'SalesOfficeDesignation' => { type: :integer, required: true },
            'SalesPosEquipmentId' => { type: :integer },
            'Uuid' => { type: :guid, required: true },
            'VatIdentificationNumber' => { type: :string, required: true }
          }.freeze }
        }.freeze },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'ExternalDocumentNumber' => { type: :string, required: true },
        'IsCumulative' => { type: :boolean, required: true },
        'IsIncomeTax' => { type: :boolean, required: true },
        'Items' => { type: :array, element: { type: :object, schema: {
          'Amount' => { type: :decimal, required: true },
          'Name' => { type: :string, required: true },
          'PriceListItemId' => { type: :integer },
          'PriceType' => { type: :enum, required: true, enum: :price_type },
          'Unit' => { type: :string },
          'UnitPrice' => { type: :decimal, required: true },
          'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
        }.freeze } },
        'Name' => { type: :string, required: true },
        'Note' => { type: :string },
        'PartnerId' => { type: :integer },
        'Payments' => { type: :array, element: { type: :object, schema: {
          'PaymentAmount' => { type: :decimal },
          'PaymentOptionId' => { type: :integer },
          'PaymentTransactionCode' => { type: :string, required: true }
        }.freeze } },
        'SalesPosEquipmentId' => { type: :integer },
        'Tags' => { type: :array, element: { type: :integer } }
      }.freeze

      CREATE_SCHEMA = RECEIPT_SCHEMA

      CREATE_BATCH_SCHEMA = {
        'Items' => { type: :array, element: { type: :object, schema: RECEIPT_SCHEMA } }
      }.freeze

      RECOUNT_SCHEMA = {
        'CurrencyId' => { type: :integer },
        'DateOfIssue' => { type: :date, required: true },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'Items' => { type: :array, required: true, element: { type: :object, schema: {
          'Amount' => { type: :decimal, required: true },
          'Id' => { type: :integer },
          'ItemType' => { type: :enum, enum: :item_type },
          'Name' => { type: :string },
          'PriceType' => { type: :enum, required: true, enum: :price_type },
          'UnitPrice' => { type: :decimal, required: true },
          'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
        }.freeze } },
        'Payments' => { type: :array, element: { type: :object, schema: {
          'PaymentOptionId' => { type: :integer }
        }.freeze } }
      }.freeze

      UPDATE_SCHEMA = {
        'CurrencyId' => { type: :integer },
        'DateOfIssue' => { type: :date },
        'ElectronicRecordsOfSales' => { type: :object, schema: {
          'EetResponsibility' => { type: :enum, required: true, enum: :eet_responsibility },
          'EetStatus' => { type: :enum, enum: :eet_status },
          'IsEet' => { type: :boolean, required: true },
          'RegisteredSale' => { type: :object, schema: {
            'Bkp' => { type: :string, required: true },
            'DateOfAnswer' => { type: :date, required: true },
            'DateOfSale' => { type: :date, required: true },
            'DateOfSend' => { type: :date, required: true },
            'Fik' => { type: :string, required: true },
            'Pkp' => { type: :string, required: true },
            'Prices' => { type: :object, required: true, schema: {
              'BaseTaxBasicRateHc' => { type: :decimal, required: true },
              'BaseTaxReducedRate1Hc' => { type: :decimal, required: true },
              'BaseTaxReducedRate2Hc' => { type: :decimal, required: true },
              'BaseTaxZeroRateHc' => { type: :decimal, required: true },
              'TaxBasicRateHc' => { type: :decimal, required: true },
              'TaxReducedRate1Hc' => { type: :decimal, required: true },
              'TaxReducedRate2Hc' => { type: :decimal, required: true },
              'TotalAdvancePayment' => { type: :decimal, required: true },
              'TotalFromAdvancePayment' => { type: :decimal, required: true },
              'TotalTravelServiceHc' => { type: :decimal, required: true },
              'TotalUsedGoodsBasicRateHc' => { type: :decimal, required: true },
              'TotalUsedGoodsReducedRate1Hc' => { type: :decimal, required: true },
              'TotalUsedGoodsReducedRate2Hc' => { type: :decimal, required: true },
              'TotalWithVatHc' => { type: :decimal, required: true }
            }.freeze },
            'ReceiptNumber' => { type: :string, required: true },
            'SalesOfficeDesignation' => { type: :integer, required: true },
            'SalesPosEquipmentId' => { type: :integer },
            'Uuid' => { type: :guid, required: true },
            'VatIdentificationNumber' => { type: :string, required: true }
          }.freeze }
        }.freeze },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'ExternalDocumentNumber' => { type: :string },
        'Id' => { type: :integer, required: true },
        'IsIncomeTax' => { type: :boolean },
        'Items' => { type: :array, element: { type: :object, schema: {
          'Amount' => { type: :decimal },
          'Id' => { type: :integer },
          'Name' => { type: :string, required: true },
          'PriceType' => { type: :enum, enum: :price_type },
          'Unit' => { type: :string },
          'UnitPrice' => { type: :decimal },
          'VatRateType' => { type: :enum, enum: :vat_rate_type }
        }.freeze } },
        'Name' => { type: :string },
        'Note' => { type: :string },
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
        'Payments' => { type: :array, element: { type: :object, schema: {
          'Id' => { type: :integer },
          'PaymentAmount' => { type: :decimal },
          'PaymentOptionId' => { type: :integer },
          'PaymentTransactionCode' => { type: :string, required: true }
        }.freeze } },
        'SalesPosEquipmentId' => { type: :integer },
        'Tags' => { type: :array, element: { type: :integer } }
      }.freeze

      # GET /SalesReceipts/{id}
      def detail(id, include: nil)
        check_integer!(id, 'id')
        query = {}
        query[:Include] = check_string!(include, 'include') if include
        client.request("SalesReceipts/#{id}", query)
      end

      # GET /SalesReceipts/{id}/Copy
      def copy(id)
        check_integer!(id, 'id')
        client.request("SalesReceipts/#{id}/Copy")
      end

      # GET /SalesReceipts
      def list(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        client.request('SalesReceipts',
                       list_query(filter: filter, filtertype: filtertype, sort: sort, page: page, pagesize: pagesize))
      end

      # GET /SalesReceipts/Default
      def default
        client.request('SalesReceipts/Default')
      end

      # POST /SalesReceipts
      def create(params)
        params = validate!(params, CREATE_SCHEMA)
        client.create('SalesReceipts', params)
      end

      # POST /SalesReceipts/Batch
      def create_batch(params)
        params = validate!(params, CREATE_BATCH_SCHEMA)
        client.create('SalesReceipts/Batch', params)
      end

      # POST /SalesReceipts/Recount
      def recount(params)
        params = validate!(params, RECOUNT_SCHEMA)
        client.create('SalesReceipts/Recount', params)
      end

      # PATCH /SalesReceipts (Id is part of params)
      def update(params)
        params = validate!(params, UPDATE_SCHEMA)
        client.patch('SalesReceipts', params)
      end

      # DELETE /SalesReceipts/{id}
      def delete(id)
        check_integer!(id, 'id')
        client.destroy("SalesReceipts/#{id}")
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
