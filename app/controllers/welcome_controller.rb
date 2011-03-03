class WelcomeController < ApplicationController
  def index
    @votes = Vote.limit(30)
  end
end
