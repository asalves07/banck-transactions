require 'rails_helper'

RSpec.describe Account, type: :model do
  subject { build(:account) }
  
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_uniqueness_of(:number).case_insensitive }
  it { is_expected.to validate_presence_of(:agency) }
  it { is_expected.to validate_presence_of(:type_account) }
  it { is_expected.to define_enum_for(:type_account).with_values({current: 1, saving: 2})}
  it { is_expected.to validate_presence_of(:state) }
  it { is_expected.to define_enum_for(:state).with_values({open: 1, closed: 2})}
  it { is_expected.to validate_presence_of(:balance) }
  it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
  it { is_expected.to belong_to :user }

end
