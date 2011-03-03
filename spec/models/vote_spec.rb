require 'spec_helper'

describe Vote do

  it "should vote" do
    factory_vote
    record = Vote.where({:item_id => '1', :review_id => '1'}).first
    record.votes[Vote::VoteType::INSANE].should eq 1
  end

  it "should vote as anonymous" do
    factory_vote(:user_id => nil)
    record = Vote.where({:item_id => '1', :review_id => '1'}).first
    record.votes[Vote::VoteType::INSANE].should eq 1
  end

end
