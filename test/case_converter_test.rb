# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/idoklad_client/case_converter'

class CaseConverterTest < Minitest::Test
  def test_to_pascal_case_converts_snake_case_keys
    assert_equal({ 'CompanyName' => 'Acme' }, IdokladClient::CaseConverter.to_pascal_case(company_name: 'Acme'))
  end

  def test_to_pascal_case_is_idempotent_on_already_pascal_case_keys
    assert_equal({ 'CompanyName' => 'Acme' }, IdokladClient::CaseConverter.to_pascal_case('CompanyName' => 'Acme'))
  end

  def test_to_pascal_case_handles_multi_word_and_abbreviation_keys
    result = IdokladClient::CaseConverter.to_pascal_case(vat_identification_number_sk: 'CZ123')
    assert_equal({ 'VatIdentificationNumberSk' => 'CZ123' }, result)
  end

  def test_to_pascal_case_recurses_into_nested_arrays_and_hashes
    input = { delivery_addresses: [{ city: 'Praha', is_default: true }] }
    expected = { 'DeliveryAddresses' => [{ 'City' => 'Praha', 'IsDefault' => true }] }

    assert_equal expected, IdokladClient::CaseConverter.to_pascal_case(input)
  end

  def test_to_pascal_case_leaves_non_hash_values_untouched
    assert_equal 5, IdokladClient::CaseConverter.to_pascal_case(5)
    assert_equal 'text', IdokladClient::CaseConverter.to_pascal_case('text')
    assert_nil IdokladClient::CaseConverter.to_pascal_case(nil)
  end

  def test_to_snake_case_converts_pascal_case_keys
    assert_equal({ 'company_name' => 'Acme' }, IdokladClient::CaseConverter.to_snake_case('CompanyName' => 'Acme'))
  end

  def test_to_snake_case_is_idempotent_on_already_snake_case_keys
    assert_equal({ 'company_name' => 'Acme' }, IdokladClient::CaseConverter.to_snake_case('company_name' => 'Acme'))
  end

  def test_to_snake_case_recurses_into_nested_arrays_and_hashes
    input = { 'DeliveryAddresses' => [{ 'City' => 'Praha', 'IsDefault' => true }] }
    expected = { 'delivery_addresses' => [{ 'city' => 'Praha', 'is_default' => true }] }

    assert_equal expected, IdokladClient::CaseConverter.to_snake_case(input)
  end

  def test_round_trips_between_snake_case_and_pascal_case
    original = { 'VatIdentificationNumberSk' => 'CZ123', 'DeliveryAddresses' => [{ 'PostalCode' => '11800' }] }

    round_tripped = IdokladClient::CaseConverter.to_pascal_case(IdokladClient::CaseConverter.to_snake_case(original))

    assert_equal original, round_tripped
  end
end
