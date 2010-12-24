class UsersController < ApplicationController
  before_filter :require_user,          :except => [ :activate, :new, :create ]
  before_filter :require_no_user,       :only   => [ :new, :create, :activate ]

  def index
    @user = current_user
    render :action => :index
  end

  def new
    @user = User.new
    #render :action => :new
  end

  def edit
    @user = current_user
    #render :action => :edit
  end

  def show
    @user = current_user
    #render :action => :show
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      UserMailer.register_activate_email(@user).deliver
    else
      render :action => :new
    end
  end

  def activate
    @user = User.find_using_perishable_token( params[:token] )
    if @user.nil? or @user.try('active?')
      redirect_to root_path
    else
      @user.activate!
    end
  end
end
