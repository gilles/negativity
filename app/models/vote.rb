class Vote
  include Mongoid::Document

  module VoteType
    BULLSHIT = 0
    IDIOT = 1
  end

  #user who made the vote, can be nil
  #no user a/c for now, is nil
  field :user_id, :type => BSON::ObjectId, :default => nil

  #the original URL
  field :url, :type => String

  #target of the vote (a yelp review ID)
  field :review_id, :type => String
  #target of the vote (a yelp user ID)
  field :reviewer_id, :type => String

  #vote type
  field :vote, :type => Integer

end
