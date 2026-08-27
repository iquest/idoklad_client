# frozen_string_literal: true

module IdokladClient
  # Converts Hash/Array structures (recursively, including nested Hashes and Arrays) between
  # Ruby-idiomatic snake_case keys and the PascalCase keys the iDoklad v3 API uses.
  #
  # Both directions are idempotent: a key already in the target case is returned unchanged,
  # so callers may freely mix snake_case, PascalCase, and camelCase in the same Hash.
  module CaseConverter
    module_function

    # Converts a Hash's keys (deeply) to PascalCase, e.g. :company_name => 'CompanyName'.
    def to_pascal_case(value)
      case value
      when Hash
        value.each_with_object({}) { |(key, val), out| out[pascalize(key)] = to_pascal_case(val) }
      when Array
        value.map { |element| to_pascal_case(element) }
      else
        value
      end
    end

    # Converts a Hash's keys (deeply) to snake_case, e.g. 'CompanyName' => 'company_name'.
    def to_snake_case(value)
      case value
      when Hash
        value.each_with_object({}) { |(key, val), out| out[snakeize(key)] = to_snake_case(val) }
      when Array
        value.map { |element| to_snake_case(element) }
      else
        value
      end
    end

    def pascalize(key)
      key.to_s.split('_').map { |word| word.sub(/\A[a-z]/, &:upcase) }.join
    end
    private_class_method :pascalize

    def snakeize(key)
      key.to_s
         .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
         .gsub(/([a-z\d])([A-Z])/, '\1_\2')
         .downcase
    end
    private_class_method :snakeize
  end
end
