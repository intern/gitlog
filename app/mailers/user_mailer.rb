class UserMailer < ActionMailer::Base
  default :from => "system@iforeach.com"

  def register_activate_email(user)
    @user = user
    @activate_token = user.perishable_token
    mail(:to => user.email, :subject => "Welcome to git server")
  end
end
