module ApplicationHelper

  #
  # Checks if user is currently logged in
  #
  # Returns true or false
  #
  def user_signed_in?
    User::MyBBSessionTable.exists? sid: cookies[:sid] if cookies[:sid]
  end

  #
  # Returns currently logged in member record
  #
  def current_user
    User::MyBBSessionTable.find(cookies[:sid]).user if cookies[:sid]
  end
 
end
