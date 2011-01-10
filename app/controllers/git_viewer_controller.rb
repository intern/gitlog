class GitViewerController < ApplicationController
  before_filter :user_and_repository_check?
  before_filter :set_hash_and_uri, :only => [:blob, :tree]
  before_filter :find_blob_info, :only => [:blob]

  def commits
    @commits = GitPicker.get_commit_info_by_hash(params[:username], params[:repository], 'master')
  end

  def commit
  end

  def tree
    @tree = GitPicker.get_tree_list_by_path(params[:username], params[:repository], @current_hash)
  end

  def blob
    @code = GitPicker.get_blob_plain_by_hash(params[:username], params[:repository], @current_hash)
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

    def set_hash_and_uri
      params[:tree_hash] ||= "master"
      @tree_hash = params[:tree_hash]
      if params[:path].nil?
        @current_hash = GitPicker.get_hash_by_name(params[:username], params[:repository], params[:tree_hash])
      else
        @current_hash = GitPicker.get_hash_by_path(params[:username], params[:repository], params[:tree_hash], params[:path])
#        type = GitPicker.get_type_by_hash(params[:username], "#{params[:repository]}.git", hash)
      end
    end

    def find_blob_info
      @blob_info = GitPicker.get_tree_list_by_path(params[:username], params[:repository], @tree_hash, params[:path] ).first
    end

end