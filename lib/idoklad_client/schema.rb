# frozen_string_literal: true

require 'date'

module IdokladClient
  # Raised when parameters passed to an endpoint wrapper do not match the
  # type/format documented at https://api.idoklad.cz/Help/v3/cs/index.html
  class ValidationError < ArgumentError; end

  # Recursively validates a params Hash against a schema Hash built by the
  # endpoint wrapper classes in IdokladClient::Endpoints.
  #
  # A schema is a Hash of field_name => spec, where spec is one of:
  #   { type: :string | :integer | :decimal | :boolean | :date | :guid, required: true|false }
  #   { type: :enum, enum: :price_type, required: true|false }
  #   { type: :array, element: <spec>, required: true|false }
  #   { type: :object, schema: <schema>, required: true|false }
  module Schema
    GUID_FORMAT = /\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\z/.freeze

    module_function

    def validate!(params, schema, path = '')
      unless params.is_a?(Hash)
        raise ValidationError, "#{path.empty? ? 'params' : path} must be a Hash, got #{params.class}"
      end

      normalized = params.transform_keys(&:to_s)
      errors = schema.flat_map { |field, spec| check_top(normalized, field, spec, path) }

      raise ValidationError, errors.join('; ') unless errors.empty?
    end

    def check_top(normalized, field, spec, path)
      field_path = path.empty? ? field : "#{path}.#{field}"
      return ["#{field_path} is required"] if !normalized.key?(field) && spec[:required]
      return [] unless normalized.key?(field)

      check_field(normalized[field], spec, field_path)
    end
    private_class_method :check_top

    SCALAR_VALIDATORS = {
      string: [->(v) { v.is_a?(String) }, 'a String'],
      integer: [->(v) { v.is_a?(Integer) }, 'an Integer'],
      decimal: [->(v) { v.is_a?(Numeric) }, 'a Numeric'],
      boolean: [->(v) { [true, false].include?(v) }, 'true or false'],
      date: [->(v) { valid_date?(v) }, 'a Date, Time, or ISO8601 String'],
      guid: [->(v) { valid_guid?(v) }, 'a GUID String']
    }.freeze

    def check_field(value, spec, path)
      return [] if value.nil? && !spec[:required]

      case spec[:type]
      when :enum then check_enum(value, spec, path)
      when :array then check_array(value, spec, path)
      when :object then check_object(value, spec, path)
      else check_scalar(value, spec[:type], path)
      end
    end

    def check_scalar(value, type, path)
      valid, expected = SCALAR_VALIDATORS.fetch(type)
      valid.call(value) ? [] : ["#{path} must be #{expected}, got #{value.inspect}"]
    end
    private_class_method :check_scalar

    def check_enum(value, spec, path)
      allowed = Enums::TABLE.fetch(spec[:enum]).values
      allowed.include?(value) ? [] : ["#{path} must be one of #{allowed.join(', ')}, got #{value.inspect}"]
    end
    private_class_method :check_enum

    def check_array(value, spec, path)
      return ["#{path} must be an Array, got #{value.class}"] unless value.is_a?(Array)

      value.each_with_index.flat_map { |element, index| check_field(element, spec[:element], "#{path}[#{index}]") }
    end
    private_class_method :check_array

    def check_object(value, spec, path)
      validate!(value, spec[:schema], path)
      []
    rescue ValidationError => e
      [e.message]
    end
    private_class_method :check_object

    def valid_date?(value)
      return true if value.is_a?(Date) || value.is_a?(Time)
      return false unless value.is_a?(String)

      Date.iso8601(value)
      true
    rescue ArgumentError
      false
    end

    def valid_guid?(value)
      value.is_a?(String) && GUID_FORMAT.match?(value)
    end
  end
end
