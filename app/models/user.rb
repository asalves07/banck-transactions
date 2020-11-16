class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :account
  # accepts_nested_attributes_for :account, :reject_if => :all_blank
  has_one :profile
  accepts_nested_attributes_for :profile, :reject_if => :all_blank

  after_create :create_account

  private

  def create_account
    Account.create!(
      number: Faker::Number.number(digits: 10).to_s,
      agency: "001",
      type_account: 1,
      balance: 0.0,
      state: 1,
      user: User.last
    )
  end
end
