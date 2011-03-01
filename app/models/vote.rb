# a vote, we are not storing by row but using mongodb
# atomic modifiers ($inc)
# @attr [BSON::ObjectID] user_id The user making the vote, can be anonymous
# @attr [String] url The original url
# @attr [String] item_id The main item being reviewed
# @attr [String] reviewer_id The person making the review
# @attr [Integer] vote_type The vote type,
# @attr [Integer] count The counter
class Vote
  include Mongoid::Document

  module VoteType
    INSANE = 0
    FOS    = 1 #Full of shit
    TMI    = 2 #Too much info
    #for mongoid
    def self.get(value)
      value
    end

    #for mongoid
    def self.set(value)
      value
    end
  end

  #user who made the vote, can be nil
  #no user a/c for now, is nil
  field :user_id

  #the original URL
  field :url, :type => String

  #what's being reviewed
  field :item_id, :type => String
  #the reviewer ID (a yelp user ID)
  field :reviewer_id, :type => String

  #vote type
  field :vote_type, :type => VoteType

  #number of votes
  field :votes, :type => Integer

  #our key is user_id / item_id / reviewer_id / vote_type
  index([
                [:user_id, Mongo::ASCENDING],
                [:item_id, Mongo::ASCENDING],
                [:reviewer_id, Mongo::ASCENDING],
                [:vote_type, Mongo::ASCENDING]
        ],
        :unique => true)

  #TODO more indexes depending on the requests we want to make
  #TODO create the item/reviewer leaderboard via mapreduce or port my world famous counter model

  attr_protected :count
  validates_presence_of :user_id, :url, :item_id, :reviewer_id, :vote_type, :count

  #Make a vote
  #@param [String] user_id (see #Vote)
  #@param [String] url (see #Vote)
  #@param [String] item_id (see #Vote)
  #@param [String] reviewer_id (see #Vote)
  #@param [String] vote_type (see #Vote)
  #@note This is the only method you should use to create a vote
  def self.vote(user_id, url, item_id, reviewer_id, vote_type)
    if authorized?(user_id, item_id, reviewer_id, vote_type)
      user_id  ||= User.anonymous.id
      selector = {:user_id => user_id, :item_id => item_id.to_s, :reviewer_id => reviewer_id.to_s, :vote_type => vote_type}
      update   = {'$set' => {:url => url}, '$inc' => {:votes => 1}}
      self.collection.update(selector, update, {:upsert => true})
    end
  end

  private

  # Check the combination is authorized to vote
  #@param [String] user_id (see #Vote)
  #@param [String] item_id (see #Vote)
  #@param [String] reviewer_id (see #Vote)
  #@param [String] vote_type (see #Vote)
  def self.authorized?(user_id, item_id, reviewer_id, vote_type)
    true
  end

end
