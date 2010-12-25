class RepositoriesController < ApplicationController
  def index
    @projects = current_user.projects
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.new(params[:project])
    if @project.save
      flash[:notice] = "仓库添加成功!"
    else
      render :action => :new
    end
  end

  def edit
    @project = current_user.projects.find(params[:id])
  end

  def update
    @project = current_user.projects.find(params[:id])
    if @project.update_attributes(params[:project])
      flash[:notice] = "仓库更新成功!"
      render :action => :update
    else
      render :action => :edit
    end
  end

  def destroy
    current_user.projects.find(params[:id]).destroy
    flash[:notice] = "仓库删除成功!"
    redirect_to account_repositories_path
  end

end
