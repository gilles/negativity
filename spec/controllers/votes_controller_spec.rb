require 'spec_helper'

describe VotesController do

  before(:each) do
    factory_vote()
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  it "should be able to vote" do
    vote = {:vote => {'item_id'=> '1', 'review_id' => '1', 'reviewer_id' => '1', 'url' => 'http://www', 'vote_type' => Vote::VoteType::INSANE}}
    Vote.should_receive(:vote).with(vote[:vote])
    xhr :post, :create, vote
    response.status.should eq 201
  end

  it "should be able to get votes for a review" do
    xhr(:get, :review, {:id => '1'})
    assigns[:vote].should_not be_nil
    assigns[:vote][:review_id].should_not be_nil
    assigns[:vote][:votes][Vote::VoteType::INSANE].should be 1
  end

  it "should be able to show votes for an item" do
    factory_vote(:review_id =>'2', :reviewer_id => '2')
    xhr(:get, :item, {:id => '1'})
    assigns[:votes].should_not be_nil
    assigns[:votes].count.should eq 2
  end

  it "should be able to show votes for a reviewer" do
    factory_vote(:review_id => '2', :item_id => '2')
    xhr(:get, :reviewer, {:id => '1'})
    assigns[:votes].should_not be_nil
    assigns[:votes].count.should eq 2
  end

  it "should be able to show votes for several items" do
    pending "do it"
  end

end
