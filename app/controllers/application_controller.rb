class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #
  # Filter that forces to authenticate in order to continue browsing the website
  #
  #
  def authenticate_user
    redirect_to sign_in_path unless user_signed_in? && (params[:action] != "new" && params[:controller] != "auth")
  end

  #
  # Checks if user is currently logged in
  #
  # Returns true or false
  #
  def user_signed_in?
    User::MyBBSessionTable.exists? sid: cookies[:sid] if cookies[:sid]
  end

end
