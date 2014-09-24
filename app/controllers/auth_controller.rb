
class AuthController < ApplicationController


  USER_AGENT = 'Rails App'
  MYBB_HOST = "localhost"
  MYBB_PATH = "/mybb"
  MYBB_PORT = 80

  SID_REGEX = /sid=(?<SID>\w+)/ # dont touch this

  def new
  end

  def create
    require 'uri'
    require 'net/http'
    
    sid_cookie = return_login_sid

    if User.logged_in? sid_cookie
      if User.banned? sid_cookie
        flash[:notice] = "Error: You are banned"
      else
        cookies[:sid] = sid_cookie
        flash[:notice] = "You have been successfully signed in"
      end
      redirect_to root_path
    else
      flash[:notice] = "Some errors :("
      render :new
    end
  end

  def destroy
    if User.logged_in? cookies[:sid]
      session = User::MyBBSessionTable.find(cookies[:sid])
      cookies.delete :sid
      time = Time.now
      session.user.update_attributes(lastvisit: time, lastactive: time)
      session.destroy
      flash[:notice] = "You have been successfully signed out"
    end
    redirect_to root_path
  end

  private
    def auth_params
      params.require(:auth).permit(:username, :password, :url, :remember)
    end

    def return_login_sid
      http = Net::HTTP.new(MYBB_HOST, MYBB_PORT || 80)
      data = "action=do_login&quick_login=1&quick_username=#{auth_params[:username]}&quick_remember=#{auth_params[:remember]}&quick_password=#{auth_params[:password]}&url=#{auth_params[:url]}"
      resp, data = http.post("#{MYBB_PATH}/member.php", data, {'user-agent' => USER_AGENT})
      received_cookies = resp.response['set-cookie']
      received_cookies.match(SID_REGEX)['SID']
    end

end
