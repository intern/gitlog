class UsersController < ApplicationController
  before_filter :require_user,    :except => [ :activate, :new, :create ]
  before_filter :require_no_user, :only   => [ :new, :create ]

  def index
    @user = current_user
    render 'index'
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html
    end
  end

  def show
    @user = current_user
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.register_activate_email(@user).deliver
    else
      render 'new'
    end
  end

  def activate
    @user = User.find_using_perishable_token( params[:token] )
    if @user.active?
      redirect_to root_path
    else
      @user.activate!
    end
  end
end
