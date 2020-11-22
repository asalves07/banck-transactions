class BankStatementsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_account

  def new
    @bank_statement = BankStatement.new
  end
  

  def deposit
    value = params[:value].to_f
    if @account.state == "open"
      if create_statement(@account, value, :deposit)
        crediting(@account, value)
        redirect_to accounts_path
      else
        render :new, notice: 'Deposito não efetuado'
      end
    else
      render :new, notice: 'Deposito não efetuado'
    end

  end

  def extract
    value = params[:value].to_f
    if @account.balance >= value
      if create_statement(@account, value, :extract)
        withdrawal(@account, value)
        redirect_to accounts_path
      else
        render :new, notice: 'saque não efetuado'
      end
    else
      render :new, notice: 'saque não efetuado'
    end
  end

  def transfer
    value = params[:value].to_f
    rate = rate(value)
    if @account.balance >= value && params[:number].present? && @account.state == "open"
      if create_statement(@account, value, :transfer, rate)
        withdrawal(@account, value, rate)
        to_account = movement(params[:number])
        create_statement(to_account, value, :transfer, 0.0, BankStatement.last)
        crediting(to_account, value)
        redirect_to accounts_path
      else
        render :new, notice: 'transferência não efetuado'
      end
    elsif @account.balance >= value && @account.state == "open"
      if create_statement(@account, value, :transfer, rate)
        withdrawal(@account, value, rate)
        redirect_to accounts_path
      else
        render :new, notice: 'transferência não efetuado'
      end
    end
  end

  def statement
    @bank_statements = BankStatement.created_between(params[:start_date], params[:end_date], @account.id)
  end

  private
  def load_account
    @account = User.find(current_user.id).account
  end

  def statement_params
    params.require(:bank_statement).permit(:value, :number)
  end

  def crediting(account, value)
    newValue = account.balance.to_f + value.to_f
    Account.where(id: account.id).update_all(balance: newValue)
  end

  def withdrawal(account, value, rate = 0.0)
    newValue = account.balance - value - rate
    Account.where(id: account.id).update_all(balance: newValue)
  end

  def rate (value)
    date =  Time.now.to_s
    value > 999.99 ? rate = 10.0 : rate = 0.0
    if Date.parse(date).workday? && Time.parse(date).during_business_hours?
      rate += 5.0
    else
      rate += 7.0
    end
    rate
  end

  def movement(number)
    account = Account.search_by_number(number)
    return account
  end

  def create_statement(account, value, type_transaction, rate = 0.0, transfer = nil)
    @bank_statement = BankStatement.create!(
      type_transaction: type_transaction,
      value: value,
      account: account,
      transfer: transfer,
      rate: rate
    )
    return true
  end
  
  
end
