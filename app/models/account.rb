class Account < ApplicationRecord
  belongs_to :user

  validates :number, presence: true, uniqueness: {case_sensitive: false}
  validates :agency, presence: true
  validates :type_account, presence: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates :state, presence: true

  enum type_account: {current: 1, saving: 2}
  enum state: {open: 1, closed: 2}
end
