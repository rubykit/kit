require_relative 'rails_helper'
require_relative '../lib/kit/contract'

Types = Kit::Contract::Services::Types

module TestBool
  include Kit::Contract
  include Types

  before Hash[a: Bool]
  def self.test(a:)
    [:ok]
  end
end

payloads = [
  { a: 3 },
  { a: true },
]
payloads.each do |payload|
  begin
    puts TestBool.test(payload)
  rescue => e
    puts e
  end
end

module TestOr
  include Kit::Contract
  include Types

  before Hash[a: Or[Bool, RespondTo[:valid?], Hash[b: Any], ->(value) { value == 3 }]
  after  Or[Array[Or[:ok, :error]].size(1), Array[Or[:ok, :error], Hash]].size(2)]
  def self.test(a:)
    [:ok]
  end
end

payloads = [
  { a: 3 },
  { a: true },
  { a: 4 },
]
payloads.each do |payload|
  begin
    puts TestOr.test(payload)
  rescue => e
    puts e
  end
end

