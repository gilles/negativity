class SessionController < ApplicationController

  respond_to :json

  def new
    render :text => {'X-CSRF-Token' => form_authenticity_token}.to_json
  end

end
