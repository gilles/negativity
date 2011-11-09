require 'spec_helper'

describe LeaderboardController do

  describe "GET 'places'" do
    it "should be successful" do
      get 'places'
      response.should be_success
    end
  end

  describe "GET 'reviews'" do
    it "should be successful" do
      get 'reviews'
      response.should be_success
    end
  end

  describe "GET 'people'" do
    it "should be successful" do
      get 'people'
      response.should be_success
    end
  end

end
