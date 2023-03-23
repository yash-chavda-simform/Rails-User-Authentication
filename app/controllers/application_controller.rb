class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :user_signed_in?
  
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        session[:user_id] = user.id
        @current_user = user
      end
    end
  end

  def user_signed_in?
    !current_user.nil?
  end

  def redirect_if_authenticated
    redirect_to users_path, flash:{ info: "You Are Alread Signed in"} if user_signed_in?
  end

  private
  def require_login
    unless current_user
      redirect_to users_login_path, flash:{ danger: "You need to login first"}
    end
  end
end
