class SshesController < ApplicationController
  before_filter :require_user

  def index
    @sshes = current_user.sshes  
  end

  def show
    @ssh = current_user.sshes.find(params[:id])
  end

  def new
    @ssh = Ssh.new
  end

  def create
    @ssh = current_user.sshes.new(params[:ssh])
    if @ssh.save
      flash[:notice] = "公钥添加成功!"
    else
      render :action => :new
    end
  end

  def edit
    @ssh = current_user.sshes.find(params[:id])
  end

  def update
    @ssh = current_user.sshes.find(params[:id])
    if @ssh.update_attributes(params[:ssh])
      flash[:notice] = "公钥更新成功!"
      render :action => :update
    else
      render :action => :edit
    end
  end

  def destroy
    current_user.sshes.find(params[:id]).destroy
    flash[:notice] = "公钥删除成功!"
    redirect_to account_public_keys_path
  end

end
