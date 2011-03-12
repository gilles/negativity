# a vote, we are not storing by row but using mongodb
# atomic modifiers ($inc)
# This model contains a per item / per review vote object
#
# @attr [BSON::ObjectID] user_id The user making the vote, can be anonymous
# @attr [String] item_id The main item being reviewed
# @attr [String] url The original url of the item
# @attr [String] review The review
# @attr [String] reviewer_id The person making the review
# @attr [Hash] votes The votes per {Vote::VoteType}
# @attr [Integer] count The counter
class Vote
  include Mongoid::Document

  module VoteType
    #insane
    INSANE = 'ins'
    #Full of shit
    FOS = 'fos'
    #Full of shit
    TMI = 'tmi'

    #for mongoid
    def self.get(value)
      value
    end

    #for mongoid
    def self.set(value)
      value
    end
  end

  #item_id and review_id should be unique
  #TODO check

  #what's being reviewed
  field :item_id, :type => String
  #the review ID (a yelp review id)
  field :review_id, :type => String
  #the reviewer ID (a yelp reviewer id)
  field :reviewer_id, :type => String

  #the original URL of the item
  field :url, :type => String

  #the text of the review
  field :text, :type => String

  # { vote_type : type, count : count } hash
  field :votes, :type => Object, :default => {VoteType::INSANE => 0,
                                              VoteType::FOS => 0,
                                              VoteType::TMI => 0}

  #group by item to get page leader-board
  index :item_id, :unique => true
  #group by review to get review leader-board
  index :review_id, :unique => true
  #group by reviewer to get people leader-board
  index :reviewer_id

  #Make a vote
  #
  #@param [Hash] vote
  #@option vote [String] user_id
  #@option vote [String] url
  #@option vote [String] item_id
  #@option vote [String] review_id
  #@option vote [String] reviewer_id
  #@option vote [String] vote_type
  #
  #@param [String] session_id The current session
  #
  #@see {Vote} for a description of the parameters
  #@note This is the only method you should use to create a vote
  def self.vote(vote = {}, session_id=nil)
    vote = vote.symbolize_keys
    validate!(vote, session_id)

    selector = {:item_id => vote[:item_id],
                :review_id => vote[:review_id],
                :reviewer_id => vote[:reviewer_id],
                :url => vote[:url]}
    update = {'$inc' => {"votes.#{vote[:vote_type]}" => 1}}

    self.collection.update(selector, update, {:upsert => true, :safe => true})

    #per item trend
    counter_name = 'item:'+vote[:item_id]+':'+vote[:vote_type]
    Counter.increment(counter_name)

    #per reviewer trend
    counter_name = 'reviewer:'+vote[:reviewer_id]+':'+vote[:vote_type]
    Counter.increment(counter_name)
  end

  def to_json
    {:review => review_id, :votes => votes}
  end

  private

  # Check the combination is authorized to vote
  # Example of rule: every hour per item_id/reviewer_id/vote_type for anonymous, only once for logged in
  #
  #@param [Hash] vote
  #@option vote [String] user_id
  #@option vote [String] item_id
  #@option vote [String] review_id
  #@option vote [String] reviewer_id
  #@option vote [String] vote_type
  #
  #@param [String] session_id The current session
  #
  #@see {Vote} for a description of the parameters
  def self.authorized?(vote, session_id)

    #this means I can't test this methods properly
    #TODO find a way
    return true unless Rails.env == 'production'

    #you can revote if you renew the session...
    key = vote[:user_id].to_s
    if key.blank?
      key = session_id
    end

    key += ":#{vote[:review_id]}"

    if Rails.cache.exist?(key)
      return false
    end

    Rails.cache.write(key)

  end

  def self.validate!(vote, session_id)
    [:item_id, :reviewer_id, :review_id, :url, :vote_type].each do |field|
      raise ArgumentError, "#{field} can't be empty" if vote[field].blank?
    end

    raise Exception, 'not authorized' if !authorized?(vote, session_id)
  end

end
