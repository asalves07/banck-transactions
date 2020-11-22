class BankStatement < ApplicationRecord
  belongs_to :account
  belongs_to :transfer, class_name: 'BankStatement', optional:true

  validates :type_transaction, presence: true
  validates :value, presence: true
  validates :rate, numericality: { greater_than_or_equal_to: 0}

  enum type_transaction: {deposit: 1, transfer: 2, extract: 3}

  scope :created_between, lambda {|start_date, end_date, account| where("created_at >= ? AND created_at <= ? AND account_id = ?", start_date, end_date, account )}

end
