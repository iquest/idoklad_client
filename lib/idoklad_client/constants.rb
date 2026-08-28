# frozen_string_literal: true

module IdokladClient
  ACTION_TYPES = {
    insert: 1,
    update: 2,
    delete: 3,
    payment_created: 4,
    payment_deleted: 5,
    sales_receipt_accounting: 15,
    sales_receipt_accounting_canceled: 16,
    unmark_as_deleted: 17
  }.freeze

  ENTITY_TYPES = {
    issued_invoice: 0,
    proforma_invoice: 1,
    cash_voucher: 2,
    credit_note: 3,
    bank_statement: 4,
    received_invoice: 5,
    sales_receipt: 6,
    sales_order: 7,
    recurring_invoice: 8,
    internal_document: 9,
    contact: 10,
    agenda: 11,
    price_list_item: 16,
    issued_tax_document: 25,
    received_receipt: 34
  }.freeze

  PAYMENT_STATUSES = {
    unpaid: 0,
    paid: 1,
    partial_paid: 2,
    overpaid: 3
  }.freeze
end
