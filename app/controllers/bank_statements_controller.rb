class BankStatementsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_account

  def new_transfer
    @bank_statement = BankStatement.new
  end

  def ex_transfer
    @bank_statement = BankStatement.new
  end

  def new_deposit
    @bank_statement = BankStatement.new
  end

  def new_extract
    @bank_statement = BankStatement.new
  end
  
  def deposit
    value = statement_params.values.shift.to_f
    
    if @account.state == "open"
      if create_statement(@account, value, :deposit)
        crediting(@account, value)
      else
        render :new_deposit, status: :unprocessable_entity, notice: 'Deposito não efetuado'
      end
    else
      render :new_deposit, status: :unprocessable_entity, notice: 'Deposito não efetuado'
    end
    redirect_to accounts_path
  end

  def extract
    value = statement_params.values.shift.to_f
    if @account.balance >= value
      if create_statement(@account, value, "extract")
        withdrawal(@account, value)
      else
        render :new_extract, status: :unprocessable_entity, notice: 'saque não efetuado'
      end
    else
      render :new_extract, status: :unprocessable_entity, notice: 'saque não efetuado'
    end
    redirect_to accounts_path
  end

  def transfer
    value = statement_params.values.shift.to_f
    if statement_params.values[1] != nil
      number = statement_params.values[1].empty? ? nil : statement_params.values[1]
    else
      number = nil
    end
    rate = rate(value)
    if @account.balance >= value && number != nil && @account.state == "open"
      if create_statement(@account, value, :transfer, rate)
        withdrawal(@account, value, rate)
        to_account = movement(number)
        create_statement(to_account, value, :transfer, 0.0, @bank_statement)
        crediting(to_account, value)
      else
        render :new_transfer, status: :unprocessable_entity, notice: 'transferência não efetuado'
      end
    elsif @account.balance >= value && @account.state == "open"
      if create_statement(@account, value, :transfer, rate)
        withdrawal(@account, value, rate)
      else
        render :ex_transfer, status: :unprocessable_entity, notice: 'transferência não efetuado'
      end
    else
      render :ex_transfer, status: :unprocessable_entity, notice: 'transferência não efetuado'
    end
    redirect_to accounts_path
  end

  def statement
    if params["account"].present?
      start_date = params["account"]["start_date"].empty? ? 7.day.ago.to_s : params["account"]["start_date"]
      end_date = params["account"]["end_date"].empty? ? Time.now.to_s : params["account"]["end_date"]
    else
      start_date = 7.day.ago.to_s
      end_date = Time.now.to_s
    end

    if start_date.to_date > end_date.to_date
      aux = end_date
      end_date = start_date
      start_date = aux
    end
    end_date = (end_date.to_date + 1.day).to_s
    @bank_statements = BankStatement.created_between(start_date, end_date, @account.id)
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
