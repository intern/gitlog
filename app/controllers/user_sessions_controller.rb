class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [ :new, :create, :retrieve_password ]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to account_path
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_path
  end

  def new_retrieve_password
    render :action => :new_retrieve_password
  end

  def create_retrieve_password
    @user = User.find_by_email(params[:email])
    if @user
      UserMailer.retrieve_password_email(@user).deliver      
      render :action => :create_retrieve_password
    else
      render :action => :new_retrieve_password
    end
  end
end
