class BankStatement < ApplicationRecord
  belongs_to :account
  belongs_to :transfer, class_name: 'BankStatement', optional:true

  validates :type_transaction, presence: true
  validates :value, presence: true
  validates :created_at, presence: true

  enum type_transaction: {deposit: 1, transfer: 2, extract: 3}
end
