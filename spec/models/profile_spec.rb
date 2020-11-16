require 'rails_helper'

RSpec.describe Profile, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of(:cpf) }
  it { is_expected.to define_enum_for(:gender).with_values({male: 1, female: 2})}
end
