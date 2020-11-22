require 'rails_helper'

RSpec.describe BankStatement, type: :model do
  subject { build(:bank_statement) }
  
  it { is_expected.to validate_presence_of(:type_transaction) }
  it { is_expected.to define_enum_for(:type_transaction).with_values({deposit: 1, transfer: 2, extract: 3})}
  it { is_expected.to validate_presence_of(:value) }
  it { is_expected.to belong_to :account }
  it { is_expected.to validate_numericality_of(:rate).is_greater_than_or_equal_to(0) }

  context "date" do
    # let!(:search_params) {"2020-11-11", "2020-11-17"}
    let!(:record_to_find) { create_list(:bank_statement, 3 )}
    let!(:record_to_ignore) {create(:bank_statement, created_at: "2020-12-01")}

    it "Found records between date" do
      found_records = BankStatement.created_between("2020-11-01", "2020-11-30")
      expect(found_records).to include(*record_to_find)
    end

    it "ignores records" do
      found_records = BankStatement.created_between("2020-11-01", "2020-11-30")
      expect(found_records.to_a).to_not include(*record_to_ignore)
    end
    
  end


end
