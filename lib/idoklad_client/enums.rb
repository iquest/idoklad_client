# frozen_string_literal: true

module IdokladClient
  # Enum values used by request/response fields across the iDoklad v3 API.
  # Source: https://api.idoklad.cz/Help/v3/cs/index.html
  module Enums
    PRICE_TYPE = { with_vat: 0, without_vat: 1 }.freeze
    VAT_RATE_TYPE = { reduced1: 0, basic: 1, zero: 2, reduced2: 3 }.freeze
    ITEM_TYPE = { normal: 0, round: 1, reduce: 2, discount: 3 }.freeze
    EET_RESPONSIBILITY = { idoklad: 0, external_application: 1 }.freeze
    VAT_ON_PAY_STATUS = { disabled: 0, enabled: 1, invoice_needs_taxing: 2 }.freeze
    REPORT_LANGUAGE = { cz: 1, sk: 2, en: 3, de: 4 }.freeze
    DOCUMENT_TYPE = {
      issued_invoice: 0, proforma_invoice: 1, credit_note: 3, received_invoice: 5, received_receipt: 11
    }.freeze
    MOVEMENT_TYPE = { entry: 1, issue: -1 }.freeze
    EET_STATUS = { not_registered: 1, registered: 2 }.freeze
    EXPORTED = { not_exported: 0, exported: 1, changed: 2, deleted: 3 }.freeze

    # Maps the :enum key used in endpoint schemas to its value set.
    TABLE = {
      price_type: PRICE_TYPE,
      vat_rate_type: VAT_RATE_TYPE,
      item_type: ITEM_TYPE,
      eet_responsibility: EET_RESPONSIBILITY,
      vat_on_pay_status: VAT_ON_PAY_STATUS,
      report_language: REPORT_LANGUAGE,
      document_type: DOCUMENT_TYPE,
      movement_type: MOVEMENT_TYPE,
      eet_status: EET_STATUS,
      exported: EXPORTED,
      action_type: ACTION_TYPES,
      entity_type: ENTITY_TYPES
    }.freeze
  end
end
