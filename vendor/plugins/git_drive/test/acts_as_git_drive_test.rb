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
puts Wickwall.get_hash_by_path('git', 'gd.git', 'master', 'setup.py')
class ActsAsGitDriveTest < Test::Unit::TestCase

  def test_a_hickwalls_git_config_with_should_be_default_path
    assert_equal nil, Hickwall.set_git_bin_path
  end

  def test_a_wickwalls_yaffle_text_field_should_be_last_tweet
    assert_equal "/usr/bin/git", Wickwall.set_git_bin_path
    assert_equal "/home/intern", Wickwall.set_git_repositories_root
  end

  def test_instance_method

    #instance = Hickwall.new
    #assert_equal "The first test", instance.squawk("The first test")
  end
end


#class ActsAsGitDriveTest < ActiveSupport::TestCase
#  # Replace this with your real tests.
#  test "the truth" do
#    assert true
#  end
#end
