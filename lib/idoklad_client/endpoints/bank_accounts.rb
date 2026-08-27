# frozen_string_literal: true

module IdokladClient
  module Endpoints
    # https://api.idoklad.cz/Help/v3/cs/index.html#api-BankAccounts
    class BankAccounts < Base
      CREATE_SCHEMA = {
        'AccountNumber' => { type: :string },
        'BankId' => { type: :integer },
        'CurrencyId' => { type: :integer, required: true },
        'DateInitialState' => { type: :date },
        'Iban' => { type: :string },
        'InitialState' => { type: :decimal },
        'IsDefault' => { type: :boolean },
        'Name' => { type: :string, required: true },
        'Swift' => { type: :string }
      }.freeze

      UPDATE_SCHEMA = {
        'AccountNumber' => { type: :string },
        'BankId' => { type: :integer },
        'CurrencyId' => { type: :integer },
        'DateInitialState' => { type: :date },
        'Iban' => { type: :string },
        'Id' => { type: :integer, required: true },
        'InitialState' => { type: :decimal },
        'IsDefault' => { type: :boolean },
        'Name' => { type: :string },
        'Swift' => { type: :string }
      }.freeze

      # GET /BankAccounts/{id}
      def detail(id, include: nil)
        check_integer!(id, 'id')
        query = {}
        query[:Include] = check_string!(include, 'include') if include
        client.request("BankAccounts/#{id}", query)
      end

      # GET /BankAccounts
      def list(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        client.request('BankAccounts',
                       list_query(filter: filter, filtertype: filtertype, sort: sort, page: page, pagesize: pagesize))
      end

      # POST /BankAccounts
      def create(params)
        params = validate!(params, CREATE_SCHEMA)
        client.create('BankAccounts', params)
      end

      # PATCH /BankAccounts (Id is part of params)
      def update(params)
        params = validate!(params, UPDATE_SCHEMA)
        client.patch('BankAccounts', params)
      end

      # DELETE /BankAccounts/{id}
      def delete(id)
        check_integer!(id, 'id')
        client.destroy("BankAccounts/#{id}")
      end
    end
  end
end
