require 'rails_helper'

RSpec.describe "BankStatements", type: :request do
  let!(:user) {create(:user)}

  context "GET /statement" do
  end

  context "GET /deposit" do
    let(:url) {"/deposit?value=100"}

    context "when state is open" do 
      let!(:account) {create(:account, user: user)}

      it "adds a new BankStatement" do
        expect do
          sign_in user
          get url
        end.to change(BankStatement, :count).by(1)

      end

      it "returns success status" do
        sign_in user
        get url
        expect(response).to have_http_status(:ok)
      end
    end

    context "when state is closed" do
      let!(:account) {create(:account, state: :closed, user: user)}

      it "does not adds a new BankStatement" do
        expect do
          sign_in user
          get url
        end.to_not change(BankStatement, :count)
      end

      it "returns success status" do
        sign_in user
        get url
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end

  context "POST /extract" do
    let!(:account) {create(:account, balance: 200.0, user: user)}
    
    context "When the amount is less than the balance" do
      let(:url) {"/extract?value=100"}

      it "adds a new BankStatement" do
        expect do
          sign_in user
          post url
        end.to change(BankStatement, :count).by(1)
      end

      it "returns success status" do
        sign_in user
        post url
        expect(response).to have_http_status(:ok)
      end
    end

    context "When the amount is greater than the balance" do
      let(:url) {"/extract?value=300"}
      it "does not adds a new BankStatement" do
        expect do
          sign_in user
          post url
        end.to_not change(BankStatement, :count)
      end

      it "returns success status" do
        sign_in user
        post url
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "POST /transfer" do

    context "When the amount is less than the balance and state is open" do
      let!(:account) {create(:account, balance: 200.0, user: user)}
      let(:url) {"/transfer?value=100"}

      it "adds a new BankStatement" do
        expect do
          sign_in user
          post url
        end.to change(BankStatement, :count).by(1)
      end
  
      it "returns success status" do
        sign_in user
        post url
        expect(response).to have_http_status(:ok)
      end
    end

    context "When the amount is greater than the balance and state is open" do
      let!(:account) {create(:account, balance: 200.0, user: user)}
      let(:url) {"/transfer?value=300"}
      it "does not adds a new BankStatement" do
        expect do
          sign_in user
          post url
        end.to_not change(BankStatement, :count)
      end

      it "returns success status" do
        sign_in user
        post url
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when state is closed and the amount is less than the balance" do
      let!(:account) {create(:account, state: :closed, balance: 200.0, user: user)}
      let(:url) {"/transfer?value=100"}

      it "does not adds a new BankStatement" do
        expect do
          sign_in user
          post url
        end.to_not change(BankStatement, :count)
      end

      it "returns success status" do
        sign_in user
        post url
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
        
  end
 
end
