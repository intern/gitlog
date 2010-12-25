class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :find_user_with_perishable_token, :only => [ :edit, :update ]

  def new
    render 
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_mail!
      #UserMailer.retrieve_password_email(@user).deliver
      render :action => :create
    else
      flash[:notice] = "提交的邮箱信息不存在!"
      render :action => :new
    end
  end

  def edit
    render :action => :edit
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      render :action => :update
    else
      flash[:notice] = "提交的信息不正确!"
      redirect_to edit_password_reset_path(params[:token])
    end
  end

  private
    def find_user_with_perishable_token
      @user = User.find_using_perishable_token(params[:token])
      unless @user
        redirect_to root_url
      end
    end
end
