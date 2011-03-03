require 'spec_helper'

describe SessionController do

  before(:each) do
    request.env['HTTP_ACCEPT'] = 'application/json'
  end


  it "sould issue a token" do
    xhr :get, :new
    response.should be_success
    JSON.parse(response.body).keys.should include 'X-CSRF-Token'
  end

end
