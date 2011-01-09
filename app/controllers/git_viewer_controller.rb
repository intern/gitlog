class GitViewerController < ApplicationController
  before_filter :user_and_repository_check?
  before_filter :set_tree_hash_and_uri, :only => [:tree]

  def commits
    @commits = GitPicker.get_commit_info_by_hash(params[:username], "#{params[:repository]}.git", 'master')
  end

  def commit
  end

  def tree
    params[:tree_hash] ||= "master"
    if params[:path].nil?
      hash = GitPicker.get_hash_by_name(params[:username], "#{params[:repository]}.git", params[:tree_hash])
    else
      hash = GitPicker.get_hash_by_path(params[:username], "#{params[:repository]}.git", params[:tree_hash], params[:path])
      type = GitPicker.get_type_by_hash(params[:username], "#{params[:repository]}.git", hash)
    end

    if type.nil? or type == 'tree'
      @tree = GitPicker.get_tree_list_by_path(params[:username], "#{params[:repository]}.git", hash)
    else
      @code = GitPicker.get_blob_plain_by_hash(params[:username], "#{params[:repository]}.git", hash)
      render :blob
    end
  end

  def branchs
  end

  def branch
  end

  def tags
  end

  def tag
  end

  private
    def user_and_repository_check?
      unless User.joins(:projects).where(:users => {:login => params[:username]}, :projects => {:name => params[:repository]}).exists?
        redirect_to root_path
      end
    end

    def set_tree_hash_and_uri
      params[:tree_hash] ||= "master"

    end
end
