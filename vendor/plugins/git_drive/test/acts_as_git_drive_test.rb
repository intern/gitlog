# coding: utf-8

require 'test_helper'

class Hickwall < ActiveRecord::Base
  git_config_with
end

class Wickwall < ActiveRecord::Base
  git_config_with do |c|
    c.set_git_bin_path = '/usr/bin/git'
    c.set_git_repositories_root = "/home/intern"
  end
end

class ActsAsGitDriveTest < Test::Unit::TestCase

  def test_default_path
    assert_equal nil, Hickwall.set_git_bin_path
  end

  def test_the_options
    assert_equal "/usr/bin/git", Wickwall.set_git_bin_path
    assert_equal "/home/intern", Wickwall.set_git_repositories_root
  end

  def test_get_path_by_hash_method
    #assert_equal "", Wickwall.get_hash_by_path('git', 'gs.git', 'master', 'git_server')
    assert_equal "README", Wickwall.get_path_by_hash('git', 'gs.git', 'master', '86ea89b680fa857e77c72ebcee3f33d005735b36')
    assert_equal "git_server/authorized_keys_hook.py", Wickwall.get_path_by_hash('git', 'gs.git', 'master', 'c90d91e38828dd3c1603acc0f8e8ac5cc745b401')
    #instance = Hickwall.new
    #assert_equal "The first test", instance.squawk("The first test")
  end

  def test_get_type_by_hash
    assert_equal "blob",  Wickwall.get_type_by_hash('git', 'gs.git', 'master', '86ea89b680fa857e77c72ebcee3f33d005735b36')
    assert_equal "commit",Wickwall.get_type_by_hash('git', 'gs.git', 'master', 'master')
    assert_equal "tag",   Wickwall.get_type_by_hash('git', 'gs.git', 'master', 'v0.1.0')
    assert_equal "tree",  Wickwall.get_type_by_hash('git', 'gs.git', 'master', '515a87f210ce8c62414329fd894fa9e0d31b7bb2')
  end

  def test_get_log_list_by_path
    assert_equal "blob",  Wickwall.get_log_list_by_path('git', 'gs.git', 'master', 'setup.py')
    assert_equal "blob",  Wickwall.get_log_list_by_path('git', 'gs.git', 'master', 'git_server')
  end

  def test_get_blob_plain_by_hash
    assert_equal "blob",  Wickwall.get_blob_plain_by_hash('git', 'gs.git', '07931573c4c384e012727c956c5c825b605b96bb')
  end

  def test_get_blob_plain_by_hash
    assert_equal "blob",  Wickwall.get_blob_plain_by_filepath('git', 'gs.git', 'master', 'setup.py')
  end

  def test_get_head_hash
    assert_equal "c9c0a096346adff7db2f2a33a5e13e0f69c2e2b6", Wickwall.get_head_hash('git', 'gs.git')
  end

  def test_get_hash_by_name
    assert_equal "2ec41843db960b8f50737d13a2daf312bc664ced", Wickwall.get_hash_by_name('git', 'gs.git', 'v0.1.0')
  end

  def test_get_commit_info_by_hash
    assert_equal "test_get_commit_info_by_hash", Wickwall.get_commit_info_by_hash('git', 'gs.git', 'master')
  end

  def test_get_commit_info_by_path
    assert_equal "test_get_commit_info_by_path", Wickwall.get_commit_info_by_path('git', 'gs.git', 'master', 'setup.py')
  end
end


#class ActsAsGitDriveTest < ActiveSupport::TestCase
#  # Replace this with your real tests.
#  test "the truth" do
#    assert true
#  end
#end
