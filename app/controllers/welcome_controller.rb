class WelcomeController < ApplicationController
  def index
    redirect_to votes_path
  end
end
