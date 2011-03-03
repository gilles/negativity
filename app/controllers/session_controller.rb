class SessionController < ApplicationController

  respond_to :json

  # Generates a new session and returns the current authenticity token
  def new
    render :text => {'X-CSRF-Token' => form_authenticity_token}.to_json
  end

end
