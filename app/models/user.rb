class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.ignore_blank_passwords = false
  end

  #
  def activate!
    self.active = true
    self.save(false)
    self
  end

  def to_param
    login
  end
end
