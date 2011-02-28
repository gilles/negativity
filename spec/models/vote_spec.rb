require 'spec_helper'

describe Vote do

  it "should vote" do
    Vote.vote('dude', "http://url", 1, 1, 0)
    record = Vote.where({:user_id => 'dude', :item_id => '1', :reviewer_id => '1', :vote_type => Vote::VoteType::INSANE}).first
    record.votes.should eq 1
  end

  it "should vote as anonymous" do
    Vote.vote(nil, "http://url", 1, 1, 0)
    record = Vote.where({:user_id => User.anonymous.id, :item_id => '1', :reviewer_id => '1', :vote_type => Vote::VoteType::INSANE}).first
    record.votes.should eq 1
  end

end
