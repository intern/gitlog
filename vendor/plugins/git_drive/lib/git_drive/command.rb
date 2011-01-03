# coding: utf-8

module GitDrive
  module Base
    module Command
      def execute(base, user, repository, options = [])
        @git_bin        ||= base.set_git_bin_path
        @git_repos_root ||= File.expand_path( base.set_git_repositories_root )
        git_dir_option = "--git-dir=#{@git_repos_root}/#{user}/#{repository}"
        cmd = "#{@git_bin} #{git_dir_option} #{options.join(' ')}"
        #puts cmd
        tmp = %x[#{cmd} 2> /dev/null]
        raise GitDriveCmdExecuteError unless $?.success?
        tmp
      end
    end
  end
end