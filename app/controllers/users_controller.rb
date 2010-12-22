class UsersController < ApplicationController
  before_filter :require_user,    :except => [ :new, :create ]
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
      
    else
      render 'new'
    end
  end
end
