class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_password, only:[:update]
  before_action :set_user

  def edit
    @user.build_profile if @user.profile.blank?
  end

  def update
    if @user.update(user_params)
      bypass_sign_in(@user)
      redirect_to accounts_path
    else
      render :edit
    end
  end

  private
  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, profile_attributes: [:id, :address, :gender, :birthdate, :cpf])
  end

  def verify_password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].extract!(:password, :password_confirmation)
    end
  end

end
