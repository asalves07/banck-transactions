require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  let(:user) {create(:user)}
  
  it "Test Home" do
    sign_in user
    get '/accounts'
    expect(response).to have_http_status(:ok)
  end
end
