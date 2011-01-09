class WelcomeController < ApplicationController
  def index
    @public_repos = User.joins(:projects).where(:projects => {:protected => false}).select("login, name")
  end
end
