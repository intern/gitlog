class GitViewerController < ApplicationController
  before_filter :user_and_repository_verify
  before_filter :set_default_tree_hash,   :only => [:blob, :tree]
  before_filter :set_default_commit_hash, :only => [:commit, :commits]
  before_filter :set_path_hash,    :only => [:blob, :tree]
  before_filter :find_blob_info,   :only => [:blob]
  before_filter :find_last_commit, :only => [:blob, :tree, :commit]

  def tree
    @tree = GitPicker.get_tree_list_by_path(params[:username], params[:repository], @path_hash)
  end

  def blob
    @code = GitPicker.get_blob_plain_by_hash(params[:username], params[:repository], @path_hash)
  end

  def commits
    if params[:path].nil?
      @commits = GitPicker.get_commit_info_by_hash(params[:username], params[:repository], params[:commit_hash])
    else
      @type = GitPicker.get_type_with_hash_and_path(params[:username], params[:repository], params[:commit_hash], params[:path])
      @commits = GitPicker.get_log_list_by_path(params[:username], params[:repository], params[:commit_hash], params[:path])
    end
  end

  def commit
    @diff_lists = GitPicker.git_diff_list_merge_with_hash(params[:username], params[:repository], params[:commit_hash])
  end

  def diff
    @diffs = GitPicker.git_diff_plain_with_commit_path(params[:username], params[:repository], params[:commit_hash], params[:path])
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
    def user_and_repository_verify
      unless User.joins(:projects).where(:users => {:login => params[:username]}, :projects => {:name => params[:repository]}).exists?
        redirect_to root_path
      end
    end

    def set_path_hash
      if params[:path].nil?
        @path_hash = GitPicker.get_hash_by_name(params[:username], params[:repository], params[:tree_hash])
      else
        @path_hash = GitPicker.get_hash_by_path(params[:username], params[:repository], params[:tree_hash], params[:path])
        #type = GitPicker.get_type_by_hash(params[:username], "#{params[:repository]}.git", hash)
      end
    end

    def set_default_tree_hash
      params[:tree_hash] ||= "master"
    end

    def set_default_commit_hash
      params[:commit_hash] ||= "master"
    end

    def find_blob_info
      @blob_info = GitPicker.get_tree_list_by_path(params[:username], params[:repository], params[:tree_hash], params[:path] ).first
    end

    def find_last_commit
      @last_commit = GitPicker.get_commit_info_by_hash(params[:username], params[:repository], params[:tree_hash] || params[:commit_hash], 1).first
    end
end
