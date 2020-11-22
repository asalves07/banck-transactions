class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_account

  def index
  end

  def shut
    closed(@account)
    render :index, notice: 'Conta Encerrada'
  end

  private

  def load_account
    @account = User.find(current_user.id).account
  end

  def closed(account)
    Account.where(id: account.id).update_all(state: "closed")
  end
end
