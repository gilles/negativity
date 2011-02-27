class SessionController < ApplicationController

  respond_to :json

  def create
    render :text => {'X-CSRF-Token' => form_authenticity_token}.to_json
  end

end
