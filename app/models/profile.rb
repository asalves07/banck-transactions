class Profile < ApplicationRecord
  belongs_to :user
  validates :cpf, presence: true
  enum gender: {male: 1, female: 2}
end
