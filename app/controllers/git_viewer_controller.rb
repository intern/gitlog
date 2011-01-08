class GitViewerController < ApplicationController
  before_filter :check_exists?

  def commits
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
    def check_exists?
      unless User.joins(:projects).where(:users => {:login => params[:username]}, :projects => {:name => params[:repository]}).exists?
        redirect_to root_path
      end
    end
end
