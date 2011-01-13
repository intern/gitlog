# coding: utf-8

module GitDrive
  module Base
    module ClassMethods
      # get hash of given path at given ref
      # <shell>
      #  inter@intern:~/gs.git$ git ls-tree master -- setup.py
      #  100644 blob 07931573c4c384e012727c956c5c825b605b96bb    setup.py
      # </shell>
      def get_hash_by_path(user, repository, base, path)
        execute(self, user, repository, ['ls-tree', base, '--', path]).scan(/^[0-9]+ .+ ([0-9a-fA-F]{40})\t/)
      end

      # get path of given hash at given ref
      #   blob object not is tree tag
      #   @return hash string, false if the type error
      def get_path_by_hash(user, repository, base, hash)
        #git_cmd(), "ls-tree", '-r', '-t', '-z', $base
        reg = Regexp.new("(?:[0-9]+) (?:.+) #{hash}\\t(.+)$")
        execute(self, user, repository, ['ls-tree', '-r', '-t', base]).each_line do |line|
          return $1 if line.scan(reg) and $1
        end
        return false
        # while it
      end

      # get type if given hash at given ref
      # <shell>
      #   inter@intern:~/gs.git$ git cat-file -t 07931573c4c384e01272
      #   blob
      #   inter@intern:~/gs.git$ git cat-file -t master
      #   commit
      # </shell>
      #  @return string blob | tree | commit
      def get_type_by_hash(user, repository, hash)
        execute(self, user, repository, ['cat-file', '-t', hash]).strip
      end

      # get log data with the path
      #  <shell>
      #   inter@intern:~/gs.git$ git log 31898bf7b711a9c8c0c7 -- setup.py
      #   ...
      #   inter@intern:~/gs.git$ git log master -- setup.py
      #   ...
      #  </shell>
      #  @return structure:
      #   <code>
      #    [{:author=>"lan_chi",
      #      :tree_hash=>"30ccb08801656483f906a9994853fab78144ff45",
      #      :commit_hash=>"52149f199127c8e65c5beb201368f82ba99edbb5",
      #      :comment=>"Update files, release v0.1.0",
      #      :email=>"lan_chi@foxmail.com",
      #      :date=>"2010-12-27 11:01:58 +0800"},
      #     {:author=>"lan_chi",
      #      :tree_hash=>"5207126388283c4b49ca3b163c788410d17c3849",
      #      :commit_hash=>"a7063ed2d1fddb1291e551457d8f391e3ff594a4",
      #      :comment=>"Update the setuptools install.",
      #      :email=>"lan_chi@foxmail.com",
      #      :date=>"2010-12-10 12:17:52 +0800"},
      #     {:author=>"lan_chi",
      #      :tree_hash=>"c7bb3db55b422fb91b98eb58fed0c16fbe445eba",
      #      :commit_hash=>"d27b3426fcf24b6aa37d6245389aca856f5bb145",
      #      :comment=>"Update setup option.",
      #      :email=>"lan_chi@foxmail.com",
      #      :date=>"2010-12-10 10:53:56 +0800"},
      #     {:author=>"lan_chi",
      #      :tree_hash=>"e5634753d20ca8af902345565363a1a741f67e1d",
      #      :commit_hash=>"e0496745ede2d3b4ef43e3db4a466a74fe966c67",
      #      :comment=>
      #       "Rename file 'gitinit.py' to 'git-init.py', and add python setuptools 'setup.py'",
      #      :email=>"lan_chi@foxmail.com",
      #      :date=>"2010-12-09 16:38:47 +0800"}
      #    ]
      #   </code>
      def get_log_list_by_path(user, repository, base, path)
        log_array = []
        execute(self, user, repository, ['log', base, '--format="format:%T%x09%H%x09%an%x09%ae%x09%ai%x09%s"', '--', path]).strip.each_line do |line|
          log = line.strip.split("\t")
          log_array << {:tree_hash => log.shift, :commit_hash => log.shift, :author => log.shift, :email => log.shift, :date => log.shift, :comment => log.shift}
        end
        log_array
      end

      # get the references hash the type
      # c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6 refs/heads/master
      # 2ec41843db960b8f50737d13a2daf312bc664ced refs/tags/v0.1.0
      #  <shell>
      #   inter@intern:~/gs.git$ git show-ref --dereference -- master
      #   c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6 refs/heads/master
      #   inter@intern:~/gs.git$ git show-ref --dereference -- v0.1.0
      #   2ec41843db960b8f50737d13a2daf312bc664ced refs/tags/v0.1.0
      #   31898bf7b711a9c8c0c7191e489c904c22294079 refs/tags/v0.1.0^{}
      #  </shell>
      def get_refer_hash_by_type(user, repository, base, type = nil )
        #
      end

      # get the plain text if given hash,
      #  <shell>inter@intern:~/gs.git$ git cat-file blob 07931573c4c384e012727c956c5c825b605b96bb
      #  # coding: utf-8
      #  """
      #  git-server setuptools
      #  """
      #  import os, sys, ConfigParser
      #  </shell>
      def get_blob_plain_by_hash(user, repository, hash)
        execute(self, user, repository, ['cat-file', 'blob', hash])
      end

      # get the plain text if given filename
      #  <shell>
      #  #first to get the file hash and get_blob_plain_by_hash()
      #  inter@intern:~/gs.git$ git cat-file blob 07931573c4c384e012727c956c5c825b605b96bb
      #  # coding: utf-8
      #  """
      #  git-server setuptools
      #  """
      #  import os, sys, ConfigParser
      #  </shell>
      def get_blob_plain_by_filepath(user, repository, base, filepath)
        hash = get_hash_by_path(user , repository, base, filepath)
        get_blob_plain_by_hash(user, repository, hash)
      end

      # get the tag info with tag hash-id
      #  <shell>
      #  inter@intern:~/gs.git$ git cat-file tag 2ec41843db960b8f50737d13a2daf312bc664ced
      #  object 31898bf7b711a9c8c0c7191e489c904c22294079
      #  type commit
      #  tag v0.1.0
      #  tagger lan_chi <lan_chi@foxmail.com> 1293419986 +0800
      #
      #  A draft version.
      #  </shell>
      def get_tag_info_by_hash(user, repository, hash)
        #
      end

      # get the HEAD hash with the given tag name
      #  <shell>
      #   inter@intern:~/gs.git$ git rev-parse --verify -q --short=40 HEAD
      #   c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6
      #  </shell>
      def get_head_hash(user, repository)
        get_hash_by_name(user, repository, 'HEAD')
      end

      # get the tag hash with the given name HEAD, master or tag name
      #  <shell>
      #   inter@intern:~/gs.git$ git rev-parse --verify -q --short=40 v0.1.0
      #   2ec41843db960b8f50737d13a2daf312bc664ced
      #  </shell>
      def get_hash_by_name(user, repository, name)
        execute(self, user, repository, ['rev-parse', '--verify', '-q', '--short=40', name]).strip
      end

      # Lists commit objects in reverse chronological order
      #  <shell>
      #   inter@intern:~/gs.git$ git rev-list --header --max-count=1 master
      #   c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6
      #   tree 2a3f590222ac1327cec19aeb8e3f86a4cd1a23fc
      #   parent 31898bf7b711a9c8c0c7191e489c904c22294079
      #   author lan_chi <lan_chi@foxmail.com> 1293420340 +0800
      #   committer lan_chi <lan_chi@foxmail.com> 1293420340 +0800
      #
      #       Update readme file.
      #  </shell>
      #  @return array
      #    [{:author=>"lan_chi",
      #      :tree_hash=>"2a3f590222ac1327cec19aeb8e3f86a4cd1a23fc",
      #      :parent_hash=>"31898bf7b711a9c8c0c7191e489c904c22294079",
      #      :commit_hash=>"c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6",
      #      :comment=>"Update readme file.",
      #      :email=>"lan_chi@foxmail.com",
      #      :date=>"2010-12-27 11:25:40 +0800"},
      #     {:author=>"lan_chi",
      #      :tree_hash=>"be6cf8dc64d377f649fb291adf5c61d3905e882d",
      #      :parent_hash=>"52149f199127c8e65c5beb201368f82ba99edbb5",
      #      :commit_hash=>"31898bf7b711a9c8c0c7191e489c904c22294079",
      #      :comment=>"Release v0.1.0",
      #      :email=>"lan_chi@foxmail.com",
      #      :date=>"2010-12-27 11:17:45 +0800"}
      #    ]
      def get_commit_info_by_hash(user, repository, base, count = 30)
        commit_data = []
        commits = execute(self, user, repository, ['rev-list', '--format="format:%P%x09%T%x09%an%x09%ae%x09%ai%x09%s"', "--max-count=#{count}", base]).strip
        commits.gsub(/commit ([0-9a-fA-F]{40})\n([0-9a-fA-F]{40})?\t([0-9a-fA-F]{40})\t(.+)\t(.+)\t(.+)\t(.+)/) do |p|
          commit_data << {
            :commit_hash => $1,
            :parent_hash => $2,
            :tree_hash   => $3,
            :author      => $4,
            :email       => $5,
            :date        => $6,
            :comment     => $7
          }
        end
        commit_data
      end

      #  Lists commit objects with given file name
      #  <shell>
      #   inter@intern:~/gs.git$ git rev-list --header --max-count=1 master -- setup.py
      #   52149f199127c8e65c5beb201368f82ba99edbb5
      #   tree 30ccb08801656483f906a9994853fab78144ff45
      #   parent af44eb3074316e02b931bbe0f94a81ddb43dcae5
      #   author lan_chi <lan_chi@foxmail.com> 1293418918 +0800
      #   committer lan_chi <lan_chi@foxmail.com> 1293418918 +0800
      #
      #       Update files, release v0.1.0
      #  </shell>
      #  Do't use this if list file history @see get_commit_info_by_hash
      def get_commit_info_by_path(user, repository, base, path, count = 30)
        commit_data = []
        commits = execute(self, user, repository, ['rev-list', '--format="format:%P%x09%T%x09%an%x09%ae%x09%ai%x09%s"', "--max-count=#{count}", base, '--', path]).strip
        commits.gsub(/commit ([0-9a-fA-F]{40})\n([0-9a-fA-F]{40})\t([0-9a-fA-F]{40})\t(.+)\t(.+)\t(.+)\t(.+)/) do |p|
          commit_data << {
            :commit_hash => $1,
            :parent_hase => $2,
            :tree_hash   => $3,
            :author      => $4,
            :email       => $5,
            :date        => $6,
            :comment     => $7
          }
        end
        commit_data
      end

      # List the tree
      #  <shell>
      #   intern@intern-desktop:~/git/gs.git$ git ls-tree -l master ./
      #   100644 blob 86ea89b680fa857e77c72ebcee3f33d005735b36     192    README
      #   040000 tree 515a87f210ce8c62414329fd894fa9e0d31b7bb2       -    git_server
      #   100644 blob 07931573c4c384e012727c956c5c825b605b96bb    1510    setup.py
      #  </shell>
      # @return array
      def get_tree_list_by_path(user, repository, base, path = nil)
        lists = []
        execute(self, user, repository, ['ls-tree', '-l', base, (path || './')]).each_line do |line|
          list = line.strip.split(" ") #gsub(/commit ([0-9a-fA-F]{40})\n([0-9a-fA-F]{40})\t([0-9a/)
          lists << {
            :mode => list.shift,
            :type => list.shift,
            :hash => list.shift,
            :size => list.shift.to_i,
            :path => list.shift
          }
        end
        lists
      end
      # list log with base, tree or file hash
      #  <shell>
      #   inter@intern:~/gs.git$ git log master --max-count=1
      #   commit c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6
      #   Author: lan_chi <lan_chi@foxmail.com>
      #   Date:   Mon Dec 27 11:25:40 2010 +0800
      #
      #       Update readme file.
      #  </shell> or <shell>
      #   inter@intern:~/gs.git$ git log --max-count=1 31898bf7b711a9c8c0c7191e489c904c22294079
      #   commit 31898bf7b711a9c8c0c7191e489c904c22294079
      #   Author: lan_chi <lan_chi@foxmail.com>
      #   Date:   Mon Dec 27 11:17:45 2010 +0800
      #
      #       Release v0.1.0
      #  </shell>
      def get_log_list_by_hash(user, repository, base)
        #
      end

      # tag name
      #  <shell>
      #   inter@intern:~/gs.git$ git name-rev --tag 31898bf7b711a9c8c0c7191e489c904c22294079
      #   31898bf7b711a9c8c0c7191e489c904c22294079 tags/v0.1.0^0
      #  </shell>
      def git_get_rev_name_tags(user, repository, hash)
        #
      end

      # compare tree
      #  <shell>
      #   inter@intern:~/gs.git$ git diff-tree -r 7ee7498..ef0b164
      #   :100644 100644 31395331786baece8688b9ed2ee5f02885b739f2 2cdc37321901cb71e2bf153971f41f39a0f63357 M      git_server/git_init.py
      #   :100644 100644 5b0fb38ddc4717d0205974a57c1c264df20bf00b 0a257307ec6f7125cd02e17189eb19b0d10ca287 M      git_server/git_server.py
      #   inter@intern:~/gs.git$ git diff-tree -r 7ee7498
      #   7ee7498db7f5fa72667cc36ae8c10b6e01734891
      #   :100644 100644 2cdc37321901cb71e2bf153971f41f39a0f63357 31395331786baece8688b9ed2ee5f02885b739f2 M      git_server/git_init.py
      #   :100644 100644 0a257307ec6f7125cd02e17189eb19b0d10ca287 5b0fb38ddc4717d0205974a57c1c264df20bf00b M      git_server/git_server.py
      #  </shell>
      #  @params
      #    hash_a   A commit object hash
      #    hash_b   A commit object hash, hash_a's parent hash if hash_b is nil
      def git_diff_hash_with_commit_hash(user, repository, hash_a, hash_b = nil)
        #
      end

      # To compare blob content
      def git_diff_plain_with_commit_hash(user, repository, hash_a, hash_b = nil)
        lists = []
        all = execute(self, user, repository, ['diff-tree', '-r', '-p', '--no-commit-id', "--full-index", hash_a])
        all.gsub(/(diff --git a\/([\w|-|_|\.|\/]+) b\/([\w|-|_|\.|\/]+)\n*([\w| ]+)?\nindex ([0-9a-fA-F]{40})\.\.([0-9a-fA-F]{40}) *([0-7]{6})?([\s\S]+?)@@ ([\d|\-|\+|,| ]+) @@[ ]*[\w]*((\n[ |\-|\+][\S| |\t]*)+)+)+/) do |i|
          lists << {
            :all => $1,
            :a_file => $2,
            :b_file => $3,
            :flag => $4,
            :a_hash => $5,
            :b_hash => $6,
            :file_mode => $7,
            :file_from_to => $8,
            :change_line_number => $9,
            :file_change => $10,
            :file_last_line => $11
          }
        end
        lists
      end

      # To compare blob content
      def git_diff_plain_with_commit_hash_and_path(user, repository, hash_a, hash_b, path)
        #
      end

      # To compare blob content
      def git_diff_plain_with_hash(user, repository, hash_a, hash_b)
        #
      end

      module_eval do
        include Command
      end
    end
  end
end
