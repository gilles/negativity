require 'spec_helper'

describe TotalController do

  before(:each) do
    factory_vote()
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe "GET 'item'" do
    it "should be successful" do
      xhr(:get, :item, {:id => '1'})
      assigns[:total][:item_id].should_not be_nil
      assigns[:total][:votes][Vote::VoteType::INSANE].should be 1
    end
  end

  describe "GET 'reviewer'" do
    it "should be successful" do
      xhr(:get, :reviewer, {:id => '1'})
      assigns[:total][:reviewer_id].should_not be_nil
      assigns[:total][:votes][Vote::VoteType::INSANE].should be 1
    end
  end

end
