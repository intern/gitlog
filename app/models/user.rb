class User < ActiveRecord::Base
  has_many :projects,   :dependent => :delete_all
  has_many :sshes,      :dependent => :delete_all

  validates_exclusion_of :login, :in => GitlogConfig::RESERVED_KEYWORDS
  
  acts_as_authentic do |c|
    c.ignore_blank_passwords = false
  end

  #
  def activate!
    self.active = true
    self.save(false)
    self
  end

  def deliver_password_reset_mail!
    reset_perishable_token!
    UserMailer.password_reset_email(self).deliver
  end

  #
  def to_param
    login
  end
end
