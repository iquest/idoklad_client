# frozen_string_literal: true

module IdokladClient
  module Endpoints
    # https://api.idoklad.cz/Help/v3/cs/index.html#api-BankStatements
    # rubocop:disable Metrics/ClassLength
    class BankStatements < Base
      CREATE_SCHEMA = {
        'BankAccountId' => { type: :integer, required: true },
        'ConstantSymbolId' => { type: :integer },
        'DateOfTransaction' => { type: :date, required: true },
        'Description' => { type: :string },
        'DocumentSerialNumber' => { type: :integer, required: true },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'Exported' => { type: :enum, enum: :exported },
        'IsIncomeTax' => { type: :boolean, required: true },
        'Items' => { type: :array, required: true, element: { type: :object, schema: {
          'CustomVat' => { type: :decimal },
          'Name' => { type: :string },
          'Price' => { type: :decimal, required: true },
          'PriceType' => { type: :enum, required: true, enum: :price_type },
          'VatCodeId' => { type: :integer },
          'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
        }.freeze } },
        'MovementType' => { type: :enum, required: true, enum: :movement_type },
        'PairedDocument' => { type: :object, schema: {
          'DocumentId' => { type: :integer, required: true },
          'DocumentType' => { type: :enum, required: true, enum: :document_type }
        }.freeze },
        'PartnerAccountNumber' => { type: :string },
        'PartnerBankCode' => { type: :string },
        'PartnerIban' => { type: :string },
        'PartnerId' => { type: :integer },
        'PartnerSwift' => { type: :string },
        'SpecificSymbol' => { type: :string },
        'Tags' => { type: :array, element: { type: :integer } },
        'VariableSymbol' => { type: :string }
      }.freeze

      RECOUNT_SCHEMA = {
        'CurrencyId' => { type: :integer },
        'DateOfTransaction' => { type: :date, required: true },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'Items' => { type: :array, required: true, element: { type: :object, schema: {
          'CustomVat' => { type: :decimal },
          'Id' => { type: :integer },
          'Name' => { type: :string },
          'PriceType' => { type: :enum, required: true, enum: :price_type },
          'UnitPrice' => { type: :decimal, required: true },
          'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
        }.freeze } }
      }.freeze

      PAIR_SCHEMA = {
        'AccountNumber' => { type: :string, required: true },
        'Amount' => { type: :decimal, required: true },
        'Balance' => { type: :decimal },
        'BankCode' => { type: :string, required: true },
        'ConstantSymbol' => { type: :string },
        'CurrencyCode' => { type: :string, required: true },
        'DateOfTransaction' => { type: :date },
        'Iban' => { type: :string, required: true },
        'MessageForPartner' => { type: :string },
        'MovementType' => { type: :enum, required: true, enum: :movement_type },
        'PartnerAccountNumber' => { type: :string },
        'PartnerBankCode' => { type: :string },
        'PartnerIban' => { type: :string },
        'SpecificSymbol' => { type: :string },
        'Tags' => { type: :array, element: { type: :integer } },
        'VariableSymbol' => { type: :string, required: true }
      }.freeze

      PAIR_WITH_DOCUMENT_SCHEMA = {
        'BankStatementId' => { type: :integer, required: true },
        'DocumentId' => { type: :integer, required: true },
        'DocumentType' => { type: :enum, required: true, enum: :document_type }
      }.freeze

      UPDATE_SCHEMA = {
        'BankAccountId' => { type: :integer },
        'ConstantSymbolId' => { type: :integer },
        'DateOfTransaction' => { type: :date },
        'Description' => { type: :string },
        'ExchangeRate' => { type: :decimal },
        'ExchangeRateAmount' => { type: :decimal },
        'Id' => { type: :integer, required: true },
        'IsIncomeTax' => { type: :boolean },
        'Items' => { type: :array, element: { type: :object, schema: {
          'CustomVat' => { type: :decimal },
          'Id' => { type: :integer },
          'Name' => { type: :string },
          'Price' => { type: :decimal },
          'PriceType' => { type: :enum, enum: :price_type },
          'VatCodeId' => { type: :integer },
          'VatRateType' => { type: :enum, enum: :vat_rate_type }
        }.freeze } },
        'PairedDocument' => { type: :object, schema: {
          'DocumentId' => { type: :integer },
          'DocumentType' => { type: :enum, enum: :document_type }
        }.freeze },
        'PartnerAccountNumber' => { type: :string },
        'PartnerBankCode' => { type: :string },
        'PartnerIban' => { type: :string },
        'PartnerId' => { type: :integer },
        'PartnerSwift' => { type: :string },
        'SpecificSymbol' => { type: :string },
        'Tags' => { type: :array, element: { type: :integer } },
        'VariableSymbol' => { type: :string }
      }.freeze

      # GET /BankStatements/{id}
      def detail(id, include: nil)
        check_integer!(id, 'id')
        query = {}
        query[:Include] = check_string!(include, 'include') if include
        client.request("BankStatements/#{id}", query)
      end

      # GET /BankStatements
      def list(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        client.request('BankStatements',
                       list_query(filter: filter, filtertype: filtertype, sort: sort, page: page, pagesize: pagesize))
      end

      # GET /BankStatements/BankMailHistory
      def bank_mail_history(previous_notification_id:)
        check_integer!(previous_notification_id, 'previous_notification_id')
        client.request('BankStatements/BankMailHistory', previousNotificationId: previous_notification_id)
      end

      # GET /BankStatements/Default/{movementType}
      def default_for_movement_type(movement_type)
        check_enum!(movement_type, 'movement_type', :movement_type)
        client.request("BankStatements/Default/#{movement_type}")
      end

      # GET /BankStatements/Default/{documentType}/{documentId}
      def default_for_document(document_type, document_id)
        check_enum!(document_type, 'document_type', :document_type)
        check_integer!(document_id, 'document_id')
        client.request("BankStatements/Default/#{document_type}/#{document_id}")
      end

      # POST /BankStatements
      def create(params)
        params = validate!(params, CREATE_SCHEMA)
        client.create('BankStatements', params)
      end

      # POST /BankStatements/Recount
      def recount(params)
        params = validate!(params, RECOUNT_SCHEMA)
        client.create('BankStatements/Recount', params)
      end

      # POST /BankStatements/Pair
      def pair(params)
        params = validate!(params, PAIR_SCHEMA)
        client.create('BankStatements/Pair', params)
      end

      # POST /BankStatements/PairWithDocument
      def pair_with_document(params)
        params = validate!(params, PAIR_WITH_DOCUMENT_SCHEMA)
        client.create('BankStatements/PairWithDocument', params)
      end

      # PATCH /BankStatements (Id is part of params)
      def update(params)
        params = validate!(params, UPDATE_SCHEMA)
        client.patch('BankStatements', params)
      end

      # DELETE /BankStatements/{id}
      def delete(id)
        check_integer!(id, 'id')
        client.destroy("BankStatements/#{id}")
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
