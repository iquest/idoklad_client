# frozen_string_literal: true

module IdokladClient
  # Typed wrappers around IdokladClient::Client for each iDoklad v3 endpoint group.
  # Each subclass validates parameters against the shapes documented at
  # https://api.idoklad.cz/Help/v3/cs/index.html before making the underlying call.
  module Endpoints
    # Shared validation helpers for endpoint wrapper classes.
    class Base
      # ?filter=(Field~Operator~Value), optionally chained with |
      FILTER_FORMAT = /\A\(\s*\w+\s*~\s*\w+\s*~[^()]*\)(\s*\|\s*\(\s*\w+\s*~\s*\w+\s*~[^()]*\))*\z/.freeze
      FILTER_TYPES = %w[and or].freeze
      # ?sort=Field~Asc, optionally chained with |
      SORT_FORMAT = /\A\w+~(Asc|Desc)(\|\w+~(Asc|Desc))*\z/i.freeze

      def initialize(client)
        @client = client
      end

      private

      attr_reader :client

      # Accepts snake_case, PascalCase, or camelCase keys (in any mix, at any nesting level),
      # converts them to the PascalCase the API expects, validates the result against +schema+,
      # and returns the converted params Hash for the caller to send.
      def validate!(params, schema)
        converted = CaseConverter.to_pascal_case(params)
        Schema.validate!(converted, schema)
        converted
      end

      def check_integer!(value, name)
        raise ValidationError, "#{name} must be an Integer, got #{value.class}" unless value.is_a?(Integer)

        value
      end

      def check_boolean!(value, name)
        raise ValidationError, "#{name} must be true or false, got #{value.class}" unless [true, false].include?(value)

        value
      end

      def check_string!(value, name)
        raise ValidationError, "#{name} must be a String, got #{value.class}" unless value.is_a?(String)

        value
      end

      def check_date!(value, name)
        unless Schema.valid_date?(value)
          raise ValidationError,
                "#{name} must be a Date, Time, or ISO8601 String, got #{value.inspect}"
        end

        value
      end

      def check_enum!(value, name, enum_key)
        allowed = Enums::TABLE.fetch(enum_key).values
        unless allowed.include?(value)
          raise ValidationError,
                "#{name} must be one of #{allowed.join(', ')}, got #{value.inspect}"
        end

        value
      end

      # Builds the query Hash for the standard `filter`/`filtertype`/`sort`/`page`/`pagesize`
      # list parameters shared by every "Seznam ..." (list) endpoint.
      def list_query(filter: nil, filtertype: nil, sort: nil, page: nil, pagesize: nil)
        filter_param(filter)
          .merge(filtertype_param(filtertype))
          .merge(sort_param(sort))
          .merge(page ? { page: check_integer!(page, 'page') } : {})
          .merge(pagesize ? { pagesize: check_integer!(pagesize, 'pagesize') } : {})
      end

      def filter_param(filter)
        return {} unless filter

        check_string!(filter, 'filter')
        unless FILTER_FORMAT.match?(filter)
          raise ValidationError, "filter must match the format (Field~Operator~Value), got #{filter.inspect}"
        end

        { filter: filter }
      end

      def filtertype_param(filtertype)
        return {} unless filtertype

        unless FILTER_TYPES.include?(filtertype.to_s)
          raise ValidationError, "filtertype must be one of #{FILTER_TYPES.join(', ')}, got #{filtertype.inspect}"
        end

        { filtertype: filtertype }
      end

      def sort_param(sort)
        return {} unless sort

        check_string!(sort, 'sort')
        unless SORT_FORMAT.match?(sort)
          raise ValidationError,
                "sort must match the format Field~Asc, got #{sort.inspect}"
        end

        { sort: sort }
      end
    end
  end
end
