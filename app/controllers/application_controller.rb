class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless logged_in?
      respond_to do |format|
        format.html do
          flash[:error] = t("globals.must_login")
          store_location
          redirect_to login_url
        end
        format.any(:json, :xml) do
          request_http_basic_authentication 'Web Password'
        end
      end
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to account_url
      return false
    end
  end

  def store_location(url = nil)
    session[:return_to] = url || request.request_uri
  end
end
