# frozen_string_literal: true

module IdokladClient
  module Endpoints
    # https://api.idoklad.cz/Help/v3/cs/index.html#api-PriceListItems
    class PriceListItems < Base
      # Shape of a single price list item, shared by the single and batch create endpoints.
      ITEM_SCHEMA = {
        'Amount' => { type: :decimal, required: true },
        'BarCode' => { type: :string },
        'Code' => { type: :string },
        'CurrencyId' => { type: :integer, required: true },
        'InitialDateStockBalance' => { type: :date },
        'InitialStockBalance' => { type: :decimal },
        'IsStockItem' => { type: :boolean, required: true },
        'Name' => { type: :string, required: true },
        'Price' => { type: :decimal, required: true },
        'PriceType' => { type: :enum, required: true, enum: :price_type },
        'Unit' => { type: :string },
        'VatCodeId' => { type: :integer },
        'VatRateType' => { type: :enum, required: true, enum: :vat_rate_type }
      }.freeze

      CREATE_SCHEMA = ITEM_SCHEMA

      CREATE_BATCH_SCHEMA = {
        'Items' => { type: :array, element: { type: :object, schema: ITEM_SCHEMA } }
      }.freeze

      # Shape of a single price list item update, shared by the single and batch update endpoints.
      ITEM_UPDATE_SCHEMA = {
        'Amount' => { type: :decimal },
        'BarCode' => { type: :string },
        'Code' => { type: :string },
        'CurrencyId' => { type: :integer },
        'Id' => { type: :integer, required: true },
        'IsStockItem' => { type: :boolean },
        'Name' => { type: :string },
        'Price' => { type: :decimal },
        'PriceType' => { type: :enum, enum: :price_type },
        'Unit' => { type: :string },
        'VatCodeId' => { type: :integer },
        'VatRateType' => { type: :enum, enum: :vat_rate_type }
      }.freeze

      UPDATE_SCHEMA = ITEM_UPDATE_SCHEMA

      UPDATE_BATCH_SCHEMA = {
        'Items' => { type: :array, element: { type: :object, schema: ITEM_UPDATE_SCHEMA } }
      }.freeze

      DELETE_BATCH_SCHEMA = {
        'Items' => { type: :array, element: { type: :integer } }
      }.freeze

      # GET /PriceListItems/{id}
      def detail(id, include: nil)
        check_integer!(id, 'id')
        query = {}
        query[:Include] = check_string!(include, 'include') if include
        client.request("PriceListItems/#{id}", query)
      end

      # GET /PriceListItems
      def list(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        client.request('PriceListItems',
                       list_query(filter: filter, filtertype: filtertype, sort: sort, page: page, pagesize: pagesize))
      end

      # GET /PriceListItems/Default
      def default
        client.request('PriceListItems/Default')
      end

      # POST /PriceListItems
      def create(params)
        params = validate!(params, CREATE_SCHEMA)
        client.create('PriceListItems', params)
      end

      # POST /PriceListItems/Batch
      def create_batch(params)
        params = validate!(params, CREATE_BATCH_SCHEMA)
        client.create('PriceListItems/Batch', params)
      end

      # PATCH /PriceListItems (Id is part of params)
      def update(params)
        params = validate!(params, UPDATE_SCHEMA)
        client.patch('PriceListItems', params)
      end

      # PATCH /PriceListItems/Batch
      def update_batch(params)
        params = validate!(params, UPDATE_BATCH_SCHEMA)
        client.patch('PriceListItems/Batch', params)
      end

      # DELETE /PriceListItems/{id}/{deleteIfReferenced}
      def delete(id, delete_if_referenced)
        check_integer!(id, 'id')
        check_boolean!(delete_if_referenced, 'delete_if_referenced')
        client.destroy("PriceListItems/#{id}/#{delete_if_referenced}")
      end

      # DELETE /PriceListItems/Batch/{deleteIfReferenced}
      def delete_batch(delete_if_referenced, params)
        check_boolean!(delete_if_referenced, 'delete_if_referenced')
        params = validate!(params, DELETE_BATCH_SCHEMA)
        client.destroy("PriceListItems/Batch/#{delete_if_referenced}", params)
      end
    end
  end
end
