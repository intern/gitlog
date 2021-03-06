require 'open3'

=begin
begin
  GitAPI.action(:copy, :user => 'user', :repository => 'projects', :new_repository => 'test')
rescue NotImplementedError
  print "ERROR generated......"
end
=end

module GitAPI
  #'git_API_init', 'git_API_rename', 'git_API_move', 'git_API_copy', 'git_API_delete', 'git_API_exists'
  # the python git api list, Raise NotImplementedError exception if named action not in the list
  ACTIONS_METHODS = [:init, :rename, :move, :copy, :delete, :exists, :run_key_hook]

  # Generic GitApi error exception class.
  class GitApiError < StandardError
  end

  # Raised GitApi params error exception when the need params lose {:user}
  class GitApiParamsError < GitApiError
  end

  # Raised GitApi command params error exception when the :action params not in ACTIONS_METHODS list
  class GitApiCommandParamsError < GitApiParamsError
  end

  # The main function here. Usage:
  # <code>
  #   begin
  #     GitAPI.action(:copy, :user => 'user', :repository => 'projects', :new_repository => 'test')
  #   rescue NotImplementedError
  #     print "ERROR generated......"
  #   end
  # </code>
  def self.action(command, args = {} )
    if ACTIONS_METHODS.include?(command.to_sym)
      Action.new(command, args).exec
    else
      raise GitApiCommandParamsError
    end
  end

  # Implement :action class
  class Action
    include Open3

    # This to store action. @see ACTIONS_METHODS
    attr_accessor :command

    #To store information related :action parameters
    attr_accessor :options

    # Structural parameters and action command
    # raise GitApiParamsError exception if :user or :repository is nil
    def initialize(command, options = {})
      @command = command
      @options = options
    end

    def exec
      send self.command
    end

    # Implement git-api's action :init
    # Create git project and initialize
    #   params:
    #       :user       *require
    #       :repository *require
    def init
      implement_options :user, :repository
      run_command(
        :user => self.options[:user],
        :repository => self.options[:repository]
      )
    end

    # Implement git-api's action :delete
    alias :delete :init

    # Implement git-api's action :exists
    # Check if the named project exists
    alias :exists :init


    # API for move a git to target path
    #   alias git_API_rename
    #   params:
    #       :user           *require
    #       :repository     *require
    #       :new_repository option
    #       :new_user       option
    def move
      # move and copy are min 3 args :user :repository :new_repository
      implement_options :user, :repository, :new_repository

      run_command(
        :user       => self.options[:user],
        :repository => self.options[:repository],
        :new_repository => self.options[:new_repository],
        :new_user       => self.options[:new_user]
      )
    end

    # Implement git-api's action :rename
    # API for rename a exists git project
    #   Usage @see move
    alias :rename :move

    # Implement git-api's action :copy
    # API for copy a exists git project
    #  Usage @see move
    alias :copy   :move

    # Implement fit-api's run ssh key hook
    def run_key_hook
      run_command
    end

    private
      # implement the python `git-api` methods
      # Usage:
      #    reference git-server of python API
      def run_command(options = {})
        _command = "git-api --action #{command} #{options[:user]} #{options[:repository]} #{options[:new_repository]} #{options[:new_user]}".split(' ').join(' ').strip
        print _command
        Open3.popen3(_command)
      end

      # need implement params, raise error if without the given list args.
      def implement_options(*args)
        args.each do |key|
          raise GitApiParamsError if options[key.to_sym].nil?
        end
      end
  end
end

