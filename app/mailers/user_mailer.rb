class UserMailer < ActionMailer::Base
  default :from => "system@iforeach.com"

  def register_activate_email(user)
    @user = user
    @activate_token = user.perishable_token
    mail(:to => user.email, :subject => "Welcome to git server")
  end

  def retrieve_password_email(user)
    @reset_url = user.perishable_token
    mail(:to => user.email, :subject => "Retrieve Password tip")
  end

  def new_password(user)
    mail(:to => user.email, :subject => "New password to login")
  end
end
