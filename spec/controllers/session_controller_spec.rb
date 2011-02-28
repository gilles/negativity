require 'spec_helper'

describe SessionController do

  it "sould issue a token" do
    get :new, :format => :json
    response.should be_success
    JSON.parse(response.body).keys.should include 'X-CSRF-Token'
  end

end
