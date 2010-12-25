class Ssh < ActiveRecord::Base
  belongs_to :user
  validates_presence_of   :title, :ssh_key
  validates_uniqueness_of :title
  validates_uniqueness_of :ssh_key
end
