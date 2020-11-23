class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_account

  def index
    @account
  end

  def create
    @account = Account.new(
      number: (rand 10000000000..99999999999).to_s,
      agency: "001",
      type_account: 1,
      balance: 0.0,
      state: 1,
      user: current_user
    )
    if @account.save!
      render :index
    else
      redirect_to accounts_path, notice: 'transferência não efetuado'
    end
  end
  

  def shut_down
    closed(@account)
    redirect_to accounts_path, notice: 'Conta Encerrada'
  end

  private

  def load_account
    @account = User.find(current_user.id).account
  end

  def closed(account)
    Account.where(id: account.id).update_all(state: "closed")
  end
end
