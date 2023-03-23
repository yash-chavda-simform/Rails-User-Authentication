class UsersController < ApplicationController
  before_action :redirect_if_authenticated, only: [:new, :create, :login, :authentication]
  before_action :require_login, only: [:index, :logout]

  def index; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) 
    if @user.save
      session[:user_id] = @user.id
      redirect_to users_path
    else
      redner :new 
    end
  end

  def login
  end

  def authentication
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      params[:remember_me] == '1' ? remember(@user) : forget(@user)
      flash[:success] = "Invalid Email Or Password."
      redirect_to users_path
    else
      flash.now[:danger] = "Login Successfully."
      render :login, status: :unprocessable_entity
    end
  end

  def logout
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    session.delete(:user_id)
    @current_user = nil
    flash[:success] = "Logout Successfully."
    redirect_to users_login_path
  end
  
  def remember(user)
    user.remember(user)
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Delete the permanent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
