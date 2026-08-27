# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../lib/idoklad_client'

# Records calls instead of making real HTTP requests, so endpoint wrapper tests never touch
# the network (or a real iDoklad account).
class FakeClient
  attr_reader :calls

  def initialize
    @calls = []
  end

  def request(url, params = {})
    @calls << [:get, url, params]
    { ok: true }
  end

  def create(url, params)
    @calls << [:post, url, params]
    { ok: true }
  end

  def update(url, params)
    @calls << [:put, url, params]
    { ok: true }
  end

  def patch(url, params)
    @calls << [:patch, url, params]
    { ok: true }
  end

  def destroy(url, params = nil)
    @calls << [:delete, url, params]
    { ok: true }
  end
end

# rubocop:disable Metrics/ClassLength
class EndpointsTest < Minitest::Test
  include TestHelpers

  def setup
    @fake_client = FakeClient.new
  end

  def test_contacts_create_validates_and_delegates
    contacts = IdokladClient::Endpoints::Contacts.new(@fake_client)

    contacts.create(CompanyName: 'Acme', Email: 'info@acme.test')

    assert_equal [:post, 'Contacts', { 'CompanyName' => 'Acme', 'Email' => 'info@acme.test' }], @fake_client.calls.last
  end

  def test_contacts_create_accepts_snake_case_and_converts_to_pascal_case
    contacts = IdokladClient::Endpoints::Contacts.new(@fake_client)

    contacts.create(company_name: 'Acme', delivery_addresses: [{ city: 'Praha', name: 'Home', is_default: true }])

    assert_equal [:post, 'Contacts', {
      'CompanyName' => 'Acme',
      'DeliveryAddresses' => [{ 'City' => 'Praha', 'Name' => 'Home', 'IsDefault' => true }]
    }], @fake_client.calls.last
  end

  def test_contacts_create_rejects_missing_required_field
    contacts = IdokladClient::Endpoints::Contacts.new(@fake_client)

    assert_raises(IdokladClient::ValidationError) { contacts.create(Email: 'info@acme.test') }
    assert_empty @fake_client.calls
  end

  def test_contacts_create_rejects_nested_delivery_address_missing_name
    contacts = IdokladClient::Endpoints::Contacts.new(@fake_client)

    error = assert_raises(IdokladClient::ValidationError) do
      contacts.create(CompanyName: 'Acme', DeliveryAddresses: [{ City: 'Praha' }])
    end
    assert_includes error.message, 'DeliveryAddresses[0].Name is required'
  end

  def test_contacts_list_builds_filter_sort_and_paging_query
    contacts = IdokladClient::Endpoints::Contacts.new(@fake_client)

    contacts.list(filter: '(Id~eq~5)', sort: 'Id~Asc', page: 1, pagesize: 10)

    assert_equal [:get, 'Contacts', { filter: '(Id~eq~5)', sort: 'Id~Asc', page: 1, pagesize: 10 }],
                 @fake_client.calls.last
  end

  def test_contacts_list_rejects_malformed_filter
    contacts = IdokladClient::Endpoints::Contacts.new(@fake_client)

    assert_raises(IdokladClient::ValidationError) { contacts.list(filter: 'not-a-filter') }
  end

  def test_contacts_delete_requires_integer_id
    contacts = IdokladClient::Endpoints::Contacts.new(@fake_client)

    contacts.delete(42)
    assert_equal [:delete, 'Contacts/42', nil], @fake_client.calls.last

    assert_raises(IdokladClient::ValidationError) { contacts.delete('42') }
  end

  def test_webhooks_create_validates_and_delegates
    webhooks = IdokladClient::Endpoints::Webhooks.new(@fake_client)

    webhooks.create(
      ActionType: IdokladClient::ACTION_TYPES[:insert],
      EntityType: IdokladClient::ENTITY_TYPES[:contact],
      PublicId: '550e8400-e29b-41d4-a716-446655440000'
    )
    assert_equal :post, @fake_client.calls.last.first
  end

  def test_webhooks_create_rejects_unknown_action_type
    webhooks = IdokladClient::Endpoints::Webhooks.new(@fake_client)

    assert_raises(IdokladClient::ValidationError) do
      webhooks.create(ActionType: 999, EntityType: IdokladClient::ENTITY_TYPES[:contact],
                      PublicId: '550e8400-e29b-41d4-a716-446655440000')
    end
  end

  def test_webhooks_create_rejects_malformed_public_id
    webhooks = IdokladClient::Endpoints::Webhooks.new(@fake_client)

    assert_raises(IdokladClient::ValidationError) do
      webhooks.create(ActionType: IdokladClient::ACTION_TYPES[:insert],
                      EntityType: IdokladClient::ENTITY_TYPES[:contact], PublicId: 'not-a-guid')
    end
  end

  def test_proforma_invoices_account_uses_put_on_id_scoped_url
    proforma_invoices = IdokladClient::Endpoints::ProformaInvoices.new(@fake_client)

    proforma_invoices.account(7)

    assert_equal [:put, 'ProformaInvoices/7/Account', {}], @fake_client.calls.last
  end

  def test_proforma_invoices_default_requires_template_id
    proforma_invoices = IdokladClient::Endpoints::ProformaInvoices.new(@fake_client)

    proforma_invoices.default(template_id: 3)
    assert_equal [:get, 'ProformaInvoices/Default', { templateId: 3 }], @fake_client.calls.last

    assert_raises(ArgumentError) { proforma_invoices.default }
  end

  def test_bank_statements_default_for_movement_type_validates_enum_uri_param
    bank_statements = IdokladClient::Endpoints::BankStatements.new(@fake_client)

    bank_statements.default_for_movement_type(IdokladClient::Enums::MOVEMENT_TYPE[:entry])
    assert_equal [:get, 'BankStatements/Default/1', {}], @fake_client.calls.last

    assert_raises(IdokladClient::ValidationError) { bank_statements.default_for_movement_type(3) }
  end

  def test_price_list_items_delete_requires_boolean_flag
    price_list_items = IdokladClient::Endpoints::PriceListItems.new(@fake_client)

    price_list_items.delete(1, true)
    assert_equal [:delete, 'PriceListItems/1/true', nil], @fake_client.calls.last

    assert_raises(IdokladClient::ValidationError) { price_list_items.delete(1, 'yes') }
  end

  def test_sales_receipts_create_rejects_incomplete_deeply_nested_registered_sale
    sales_receipts = IdokladClient::Endpoints::SalesReceipts.new(@fake_client)

    error = assert_raises(IdokladClient::ValidationError) { sales_receipts.create(incomplete_sales_receipt_params) }
    assert_includes error.message, 'ElectronicRecordsOfSales.RegisteredSale.Prices is required'
  end

  def test_client_memoizes_endpoint_accessors
    client = IdokladClient::Client.allocate

    assert_same client.contacts, client.contacts
    assert_instance_of IdokladClient::Endpoints::Contacts, client.contacts
  end

  private

  def incomplete_sales_receipt_params
    {
      DateOfIssue: '2026-08-10',
      DocumentSerialNumber: 1,
      ExternalDocumentNumber: 'X1',
      IsCumulative: false,
      IsIncomeTax: false,
      Name: 'Receipt',
      ElectronicRecordsOfSales: { EetResponsibility: 0, IsEet: true, RegisteredSale: { Bkp: 'x' } }
    }
  end
end
# rubocop:enable Metrics/ClassLength
