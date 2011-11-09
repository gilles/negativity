require 'spec_helper'

describe Review do

  it "should vote" do
    factory_vote
    record = Review.where({:item_id => '1', :review_id => '1'}).first
    record.votes[Negativity::VoteType::INSANE].should eq 1
  end

  it "should vote as anonymous" do
    factory_vote(:user_id => nil)
    record = Review.where({:item_id => '1', :review_id => '1'}).first
    record.votes[Negativity::VoteType::INSANE].should eq 1
  end

end
