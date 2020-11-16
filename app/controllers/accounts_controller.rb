class AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    @accounts = Account.all
  end

  def show
  end


  def edit
  end

  def shut
  end

end
