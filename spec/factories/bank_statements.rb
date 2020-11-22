FactoryBot.define do
  factory :bank_statement do
    type_transaction { %i(deposit transfer extract).sample }
    value { "9.99" }
    rate {"7.0"}
    account { build(:account) }
    sequence(:created_at) { |n|  Faker::Date.between(from: "2020-11-#{n+1}", to: "2020-11-25") }
  end
end
