require 'rails_helper'

RSpec.describe "Accounts", type: :request do
  let(:user) {create(:user)}
  
  context "GET /accounts " do
    let(:url) {"/accounts"}
    let!(:account) {create(:account, user: user)}

    it "returns success status" do
      sign_in user
      get url
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /accounts" do
    let(:url) {"/accounts"}
    
    it "add a new Account" do
      expect do
        sign_in user
        post url
      end.to change(Account, :count).by(1)
    end

    it 'returns last added Account' do
      sign_in user
      post url
      expected_account = Account.last
      expect(response.body).to include(expected_account.number)
      expect(response.body).to include(expected_account.agency)
      expect(response.body).to include(expected_account.type_account)
      expect(response.body).to include(expected_account.balance.to_s)
      expect(response.body).to include(expected_account.state)
    end

    it "returns success status" do
      sign_in user
      post url
      expect(response).to have_http_status(:ok)
    end
  end

  context "PATCH /accounts/:id" do
    let!(:account) {create(:account, user: user)}
    let(:url) {"/accounts/#{account.id}"}
    let(:new_state){"closed"}

    it 'updates account' do
      sign_in user
      patch url
      account.reload
      expect(account.state).to eq new_state
    end

    it "returns success status" do
      sign_in user
      patch url
      expect(response).to have_http_status(:ok)
    end
  end
end
