class SessionsController < ApplicationController
  include Constants

  def new
  end

  def create
    app_id = auth_hash.extra.raw_info.app[ID_CODE]
    if app_id == ENV['REQUIRED_APP_ID']
      user = User.find_or_create_from_auth_hash(auth_hash)
      session[:user_id] = user.id
      session[:expires_at] = 14.days.from_now
      flash[:success] = "You have successfully logged in"
      redirect_to root_path
    else
      flash[:danger] = "You don't have permission to access this platform"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have logged out successfully"
    redirect_to login_path
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end
end