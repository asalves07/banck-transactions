FactoryBot.define do
  factory :profile do
    address {Faker::Address.full_address}
    cpf {Faker::CPF.cpf}
    gender { %i(male famale).sample }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 65)}
    sequence(:cpf) { |n| "cpf #{n}" }
    user { build(:user) }
  end
end
