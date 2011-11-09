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
class Review
  include Mongoid::Document

  #item_id and review_id should be unique
  #TODO check

  #what's being reviewed (a yelp place id)
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
  field :votes, :type => Object, :default => {Negativity::VoteType::INSANE => 0,
                                              Negativity::VoteType::FOS    => 0,
                                              Negativity::VoteType::TMI    => 0}

  index :review_id, :unique => true

  index 'votes.ins'
  index 'votes.fos'
  index 'votes.tmi'

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
  #@see {Vote} for a description of the parameters
  #@note This is the only method you should use to create a vote
  def self.vote(vote)
    vote = vote.symbolize_keys

    selector = {:review_id   => vote[:review_id]}
    update   = {'$inc' => {"votes.#{vote[:vote_type]}" => 1}}
    update['$set'] = {'text' => vote[:text]} unless vote[:text].blank?
    update['$set'] = {'url' => vote[:url]} unless vote[:url].blank?
    update['$set'] = {'item_id' => vote[:item_id]} unless vote[:item_id].blank?

    self.collection.update(selector, update, {:upsert => true})
  end

  def to_json
    {:review => review_id, :votes => votes}
  end

  private

end
