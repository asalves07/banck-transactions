FactoryBot.define do
  factory :account do
    sequence(:number) { |n| "number #{n}" }
    agency { "001" }
    type_account { %i(current saving).sample }
    balance { "0.0" }
    state { %i(open closed).sample }
    user { build(:user) }
  end
end
