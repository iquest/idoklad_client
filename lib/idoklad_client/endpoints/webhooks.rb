# frozen_string_literal: true

module IdokladClient
  module Endpoints
    # https://api.idoklad.cz/Help/v3/cs/index.html#api-Webhooks
    class Webhooks < Base
      CREATE_SCHEMA = {
        'ActionType' => { type: :enum, enum: :action_type, required: true },
        'EntityType' => { type: :enum, enum: :entity_type, required: true },
        'PublicId' => { type: :guid, required: true }
      }.freeze

      # GET /Webhooks/{id}
      def detail(id)
        check_integer!(id, 'id')
        client.request("Webhooks/#{id}")
      end

      # GET /Webhooks
      def list(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        client.request('Webhooks',
                       list_query(filter: filter, filtertype: filtertype, sort: sort, page: page, pagesize: pagesize))
      end

      # POST /Webhooks
      def create(params)
        params = validate!(params, CREATE_SCHEMA)
        client.create('Webhooks', params)
      end

      # DELETE /Webhooks/{id}
      def delete(id)
        check_integer!(id, 'id')
        client.destroy("Webhooks/#{id}")
      end
    end
  end
end
