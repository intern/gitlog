class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  helper_method :current_user_session, :current_user, :logged_in?



  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  alias_method :logged_in?, :current_user

  def require_user
    unless logged_in?
      respond_to do |format|
        format.html do
          flash[:error] = "必须登录!"
          store_location
          redirect_to login_url
        end
      end
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to edit_account_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end
end
