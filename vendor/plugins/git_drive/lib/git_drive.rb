# coding: utf-8

require 'git_drive/exceptions'
require 'git_drive/command'
require 'git_drive/class_methods'
require 'git_drive/instance_methods'
require 'git_drive/base'

#module GitDrive
#  module Base
#    def self.included(klass)
#      klass.class_eval do
#        extend Config
#        extend Action
#      end
#    end
#
#    module Config
#      attr_accessor :set_git_bin_path, :set_git_repositories_root
#      def git_config_with(&block)
#        yield self if block_given?
#      end
#    end
#  end
#end
#
##GitDrive::Base::Config.set_git_bin_path = '/usr/bin/git'
##GitDrive::Base::Config.set_git_repositories_root = "~/repositories"
#
#module GitDrive
#  module Base
#    module Command
#      def execute(base, user, repository, options = [])
#        @git_bin        ||= base.set_git_bin_path
#        @git_repos_root ||= File.expand_path( base.set_git_repositories_root )
#        git_dir_option = "--git-dir=#{@git_repos_root}/#{user}/#{repository}"
#        cmd = "#{@git_bin} #{git_dir_option} #{options.join(' ')}"
#        %x[#{cmd}]
#      end
#    end
#
#    class Action
#      class << self
#        # get hash of given path at given ref
#        # <shell>
#        #  inter@intern:~/gs.git$ git ls-tree master -- setup.py
#        #  100644 blob 07931573c4c384e012727c956c5c825b605b96bb    setup.py
#        # </shell>
#        def get_hash_by_path(user, repository, base, path, type='blob')
#              execute(self, user, repository, ['ls-tree', base, '--', path])
#              #git_cmd(), "ls-tree", $base, "--", $path
#        end
#
#        # get path of given hash at given ref
#        def get_path_by_hash(user, repository, base, hash)
#          #git_cmd(), "ls-tree", '-r', '-t', '-z', $base
#          # while it
#        end
#
#        # get type if given hash at given ref
#        # <shell>
#        #   inter@intern:~/gs.git$ git cat-file -t 07931573c4c384e01272
#        #   blob
#        #   inter@intern:~/gs.git$ git cat-file -t master
#        #   commit
#        # </shell>
#        def get_type_by_hash(user, repository, base, hash)
#          #
#        end
#
#        # get log data with the path
#        #  <shell>
#        #   inter@intern:~/gs.git$ git log 31898bf7b711a9c8c0c7 -- setup.py
#        #   ...
#        #   inter@intern:~/gs.git$ git log master -- setup.py
#        #   ...
#        #  </shell>
#        def get_log_by_path(user, repository, base, path)
#          #
#        end
#
#        # get the references hash the type
#        # c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6 refs/heads/master
#        # 2ec41843db960b8f50737d13a2daf312bc664ced refs/tags/v0.1.0
#        #  <shell>
#        #   inter@intern:~/gs.git$ git show-ref --dereference -- master
#        #   c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6 refs/heads/master
#        #   inter@intern:~/gs.git$ git show-ref --dereference -- v0.1.0
#        #   2ec41843db960b8f50737d13a2daf312bc664ced refs/tags/v0.1.0
#        #   31898bf7b711a9c8c0c7191e489c904c22294079 refs/tags/v0.1.0^{}
#        #  </shell>
#        def get_refer_hash_by_type(user, repository, base, type = nil )
#          #
#        end
#
#        # get the plain text if given hash,
#        #  <shell>inter@intern:~/gs.git$ git cat-file blob 07931573c4c384e012727c956c5c825b605b96bb
#        #  # coding: utf-8
#        #  """
#        #  git-server setuptools
#        #  """
#        #  import os, sys, ConfigParser
#        #  </shell>
#        def get_blob_plain_by_hash(user, repository, hash)
#          #
#        end
#
#        # get the plain text if given filename
#        #  <shell>
#        #  #first to get the file hash and get_blob_plain_by_hash()
#        #  inter@intern:~/gs.git$ git cat-file blob 07931573c4c384e012727c956c5c825b605b96bb
#        #  # coding: utf-8
#        #  """
#        #  git-server setuptools
#        #  """
#        #  import os, sys, ConfigParser
#        #  </shell>
#        def get_blob_plain_by_filename(user, repository, base, name)
#          #
#        end
#
#        # get the tag info with tag hash-id
#        #  <shell>
#        #  inter@intern:~/gs.git$ git cat-file tag 2ec41843db960b8f50737d13a2daf312bc664ced
#        #  object 31898bf7b711a9c8c0c7191e489c904c22294079
#        #  type commit
#        #  tag v0.1.0
#        #  tagger lan_chi <lan_chi@foxmail.com> 1293419986 +0800
#        #
#        #  A draft version.
#        #  </shell>
#        def get_tag_info_by_hash(user, repository, hash)
#          #
#        end
#
#        # get the HEAD hash with the given tag name
#        #  <shell>
#        #   inter@intern:~/gs.git$ git rev-parse --verify -q --short=40 HEAD
#        #   c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6
#        #  </shell>
#        def get_head_hash(user, repository)
#          #
#        end
#
#        # get the tag hash with the given name HEAD, master or tag name
#        #  <shell>
#        #   inter@intern:~/gs.git$ git rev-parse --verify -q --short=40 v0.1.0
#        #   2ec41843db960b8f50737d13a2daf312bc664ced
#        #  </shell>
#        def get_hash_by_name(user, repository, name)
#          #
#        end
#
#        # Lists commit objects in reverse chronological order
#        #  <shell>
#        #   inter@intern:~/gs.git$ git rev-list --header --max-count=1 master
#        #   c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6
#        #   tree 2a3f590222ac1327cec19aeb8e3f86a4cd1a23fc
#        #   parent 31898bf7b711a9c8c0c7191e489c904c22294079
#        #   author lan_chi <lan_chi@foxmail.com> 1293420340 +0800
#        #   committer lan_chi <lan_chi@foxmail.com> 1293420340 +0800
#        #
#        #       Update readme file.
#        #  </shell>
#        def get_commit_info_by_hash(user, repository, base)
#          #
#        end
#
#        #  Lists commit objects with given file name
#        #  <shell>
#        #   inter@intern:~/gs.git$ git rev-list --header --max-count=1 master -- setup.py
#        #   52149f199127c8e65c5beb201368f82ba99edbb5
#        #   tree 30ccb08801656483f906a9994853fab78144ff45
#        #   parent af44eb3074316e02b931bbe0f94a81ddb43dcae5
#        #   author lan_chi <lan_chi@foxmail.com> 1293418918 +0800
#        #   committer lan_chi <lan_chi@foxmail.com> 1293418918 +0800
#        #
#        #       Update files, release v0.1.0
#        #  </shell>
#        #  Do't use this if list file history @see
#        def get_commit_info_by_path(user, repository, base, path)
#          #
#        end
#
#        # list log with path
#        #  <shell>
#        #   inter@intern:~/gs.git$ git log master --max-count=1 -- setup.py
#        #   commit 52149f199127c8e65c5beb201368f82ba99edbb5
#        #   Author: lan_chi <lan_chi@foxmail.com>
#        #   Date:   Mon Dec 27 11:01:58 2010 +0800
#        #
#        #       Update files, release v0.1.0
#        #  </shell>
#        def get_log_list_by_path(user, repository, base, path)
#          #
#        end
#
#        # list log with base, tree or file hash
#        #  <shell>
#        #   inter@intern:~/gs.git$ git log master --max-count=1
#        #   commit c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6
#        #   Author: lan_chi <lan_chi@foxmail.com>
#        #   Date:   Mon Dec 27 11:25:40 2010 +0800
#        #
#        #       Update readme file.
#        #  </shell> or <shell>
#        #   inter@intern:~/gs.git$ git log  --max-count=1 31898bf7b711a9c8c0c7191e489c904c22294079
#        #   commit 31898bf7b711a9c8c0c7191e489c904c22294079
#        #   Author: lan_chi <lan_chi@foxmail.com>
#        #   Date:   Mon Dec 27 11:17:45 2010 +0800
#        #
#        #       Release v0.1.0
#        #  </shell>
#        def get_log_list_by_hash(user, repository, base)
#          #
#        end
#
#        # tag name
#        #  <shell>
#        #   inter@intern:~/gs.git$ git name-rev --tag 31898bf7b711a9c8c0c7191e489c904c22294079
#        #   31898bf7b711a9c8c0c7191e489c904c22294079 tags/v0.1.0^0
#        #  </shell>
#        def git_get_rev_name_tags(user, repository, hash)
#          #
#        end
#
#        # compare tree
#        #  <shell>
#        #   inter@intern:~/gs.git$ git diff-tree -r 7ee7498..ef0b164
#        #   :100644 100644 31395331786baece8688b9ed2ee5f02885b739f2 2cdc37321901cb71e2bf153971f41f39a0f63357 M      git_server/git_init.py
#        #   :100644 100644 5b0fb38ddc4717d0205974a57c1c264df20bf00b 0a257307ec6f7125cd02e17189eb19b0d10ca287 M      git_server/git_server.py
#        #   inter@intern:~/gs.git$ git diff-tree -r 7ee7498
#        #   7ee7498db7f5fa72667cc36ae8c10b6e01734891
#        #   :100644 100644 2cdc37321901cb71e2bf153971f41f39a0f63357 31395331786baece8688b9ed2ee5f02885b739f2 M      git_server/git_init.py
#        #   :100644 100644 0a257307ec6f7125cd02e17189eb19b0d10ca287 5b0fb38ddc4717d0205974a57c1c264df20bf00b M      git_server/git_server.py
#        #  </shell>
#        #  @params
#        #    hash_a   A commit object hash
#        #    hash_b   A commit object hash, hash_a's parent hash if hash_b is nil
#        def git_diff_hash_with_commit_hash(user, repository, hash_a, hash_b = nil)
#          #
#        end
#
#        # To compare blob content
#        def git_diff_plain_with_commit_hash(user, repository, hash_a, hash_b)
#          #
#        end
#
#        # To compare blob content
#        def git_diff_plain_with_commit_hash_and_path(user, repository, hash_a, hash_b, path)
#          #
#        end
#
#        # To compare blob content
#        def git_diff_plain_with_hash(user, repository, hash_a, hash_b)
#          #
#        end
#      end
#    end
#    Action.class_eval do
#      extend GitDrive::Base::Command
#      extend GitDrive::Base::Config
#    end
##    Action.send :extend, GitDrive::Base::Command
##    Action.send :include, GitDrive::Base::Config
#  end
#end
#
#class Action < GitDrive::Base::Action
#  git_config_with do |c|
#    c.set_git_bin_path = '/usr/bin/git'
#    c.set_git_repositories_root = "~/repositories"
#  end
#end
#
##puts Action.methods.sort
#puts Action.get_hash_by_path('intern', 'git_server', 'master', 'setup.py')