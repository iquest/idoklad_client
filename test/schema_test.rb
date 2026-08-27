# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/idoklad_client/constants'
require_relative '../lib/idoklad_client/enums'
require_relative '../lib/idoklad_client/schema'

class SchemaTest < Minitest::Test
  def test_accepts_valid_flat_params
    schema = { 'Name' => { type: :string, required: true }, 'Age' => { type: :integer } }

    IdokladClient::Schema.validate!({ 'Name' => 'Acme' }, schema)
  end

  def test_raises_on_missing_required_field
    schema = { 'Name' => { type: :string, required: true } }

    error = assert_raises(IdokladClient::ValidationError) { IdokladClient::Schema.validate!({}, schema) }
    assert_includes error.message, 'Name is required'
  end

  def test_raises_on_wrong_scalar_type
    schema = { 'Age' => { type: :integer } }

    error = assert_raises(IdokladClient::ValidationError) { IdokladClient::Schema.validate!({ 'Age' => '5' }, schema) }
    assert_includes error.message, 'Age must be an Integer'
  end

  def test_ignores_missing_optional_field
    schema = { 'Age' => { type: :integer } }

    IdokladClient::Schema.validate!({}, schema)
  end

  def test_validates_nested_object
    schema = { 'Address' => { type: :object, schema: { 'City' => { type: :string, required: true } } } }

    error = assert_raises(IdokladClient::ValidationError) do
      IdokladClient::Schema.validate!({ 'Address' => {} }, schema)
    end
    assert_includes error.message, 'Address.City is required'
  end

  def test_validates_array_of_objects_with_index_in_path
    schema = { 'Items' => { type: :array, element: { type: :object, schema: {
      'Name' => { type: :string, required: true }
    } } } }

    error = assert_raises(IdokladClient::ValidationError) do
      IdokladClient::Schema.validate!({ 'Items' => [{ 'Name' => 'ok' }, {}] }, schema)
    end
    assert_includes error.message, 'Items[1].Name is required'
  end

  def test_validates_array_of_scalars
    schema = { 'Tags' => { type: :array, element: { type: :integer } } }

    error = assert_raises(IdokladClient::ValidationError) do
      IdokladClient::Schema.validate!({ 'Tags' => [1, 'two'] }, schema)
    end
    assert_includes error.message, 'Tags[1] must be an Integer'
  end

  def test_validates_enum_against_known_values
    schema = { 'ActionType' => { type: :enum, enum: :action_type, required: true } }

    IdokladClient::Schema.validate!({ 'ActionType' => IdokladClient::ACTION_TYPES[:insert] }, schema)

    error = assert_raises(IdokladClient::ValidationError) do
      IdokladClient::Schema.validate!({ 'ActionType' => 999 }, schema)
    end
    assert_includes error.message, 'ActionType must be one of'
  end

  def test_validates_date_as_iso8601_string_time_or_date
    schema = { 'DateOfIssue' => { type: :date, required: true } }

    IdokladClient::Schema.validate!({ 'DateOfIssue' => '2026-08-10' }, schema)
    IdokladClient::Schema.validate!({ 'DateOfIssue' => Date.today }, schema)

    error = assert_raises(IdokladClient::ValidationError) do
      IdokladClient::Schema.validate!({ 'DateOfIssue' => 'not-a-date' }, schema)
    end
    assert_includes error.message, 'DateOfIssue must be a Date'
  end

  def test_validates_guid_format
    schema = { 'PublicId' => { type: :guid, required: true } }

    IdokladClient::Schema.validate!({ 'PublicId' => '550e8400-e29b-41d4-a716-446655440000' }, schema)

    error = assert_raises(IdokladClient::ValidationError) do
      IdokladClient::Schema.validate!({ 'PublicId' => 'not-a-guid' }, schema)
    end
    assert_includes error.message, 'PublicId must be a GUID String'
  end

  def test_accepts_string_or_symbol_keys
    schema = { 'Name' => { type: :string, required: true } }

    IdokladClient::Schema.validate!({ Name: 'Acme' }, schema)
  end

  def test_collects_multiple_errors_at_once
    schema = { 'Name' => { type: :string, required: true }, 'Age' => { type: :integer, required: true } }

    error = assert_raises(IdokladClient::ValidationError) { IdokladClient::Schema.validate!({}, schema) }
    assert_includes error.message, 'Name is required'
    assert_includes error.message, 'Age is required'
  end

  def test_raises_when_params_is_not_a_hash
    assert_raises(IdokladClient::ValidationError) { IdokladClient::Schema.validate!('nope', {}) }
  end
end
