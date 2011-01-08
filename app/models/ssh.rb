require 'git_api'
class Ssh < ActiveRecord::Base
  belongs_to :user
  validates_presence_of   :title, :ssh_key
  validates_uniqueness_of :title
  validates_uniqueness_of :ssh_key

  after_commit :run_key_hook

  def run_key_hook
    logger.debug("*************ssh key count: #{Ssh.count}*****")
    a,b,c = GitAPI.action(:run_key_hook)
    logger.debug("************* run key hook: #{c.read} : #{b.read} ***#{a}**")
  end
end
