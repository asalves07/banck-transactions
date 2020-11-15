FactoryBot.define do
  factory :bank_statement do
    type_transaction { %i(deposit transfer extract).sample }
    value { "9.99" }
    account { build(:account) }
  end
end
