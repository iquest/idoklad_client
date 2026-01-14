# frozen_string_literal: true

require_relative 'test_helper'

class ClientTest < Minitest::Test
  include TestHelpers

  FakeResponse = Struct.new(:parsed)

  class FakeAccess
    attr_reader :urls

    def initialize(parsed = {})
      @parsed = parsed
      @urls = []
    end

    def get(url)
      @urls << url
      FakeResponse.new(@parsed)
    end
  end

  def test_request
    client = build_client

    result = client.request('Contacts')

    assert_equal(0, result.error_code)
  end
end
