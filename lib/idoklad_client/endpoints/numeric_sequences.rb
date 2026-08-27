# frozen_string_literal: true

module IdokladClient
  module Endpoints
    # https://api.idoklad.cz/Help/v3/cs/index.html#api-NumericSequences
    class NumericSequences < Base
      UPDATE_SCHEMA = {
        'Id' => { type: :integer, required: true },
        'IsDefault' => { type: :boolean },
        'LastNumber' => { type: :integer },
        'Name' => { type: :string },
        'NumberFormat' => { type: :string },
        'Year' => { type: :integer }
      }.freeze

      # GET /NumericSequences/{id}
      def detail(id, year:)
        check_integer!(id, 'id')
        check_integer!(year, 'year')
        client.request("NumericSequences/#{id}", year: year)
      end

      # GET /NumericSequences
      def list(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        client.request('NumericSequences',
                       list_query(filter: filter, filtertype: filtertype, sort: sort, page: page, pagesize: pagesize))
      end

      # GET /NumericSequences/DocumentNumbers/{documentType}
      def document_numbers(document_type, date:, document_serial_number:, numeric_sequence_id:)
        check_enum!(document_type, 'document_type', :document_type)
        check_date!(date, 'date')
        check_integer!(document_serial_number, 'document_serial_number')
        check_integer!(numeric_sequence_id, 'numeric_sequence_id')
        client.request(
          "NumericSequences/DocumentNumbers/#{document_type}",
          date: date, documentSerialNumber: document_serial_number, numericSequenceId: numeric_sequence_id
        )
      end

      # PATCH /NumericSequences (Id is part of params)
      def update(params)
        params = validate!(params, UPDATE_SCHEMA)
        client.patch('NumericSequences', params)
      end
    end
  end
end
