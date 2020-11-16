Account.create!(
  number: Faker::Number.number(digits: 10).to_s,
  agency: "001",
  type_account: 1,
  balance: 0.0,
  state: 1,
  user_id: User.find(current_user.id)
)