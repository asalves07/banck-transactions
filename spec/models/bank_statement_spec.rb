require 'rails_helper'

RSpec.describe BankStatement, type: :model do
  subject { build(:bank_statement) }
  
  it { is_expected.to validate_presence_of(:type_transaction) }
  it { is_expected.to define_enum_for(:type_transaction).with_values({deposit: 1, transfer: 2, extract: 3})}
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to validate_presence_of(:created_at) }
  it { is_expected.to belong_to :account }
end
