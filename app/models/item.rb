#right now I vote but this can be infered from Review with MR
class Item
  include Mongoid::Document

  #what's being reviewed (a yelp place id)
  field :item_id, :type => String

  #the original URL of the item
  field :url, :type => String

  # { vote_type : type, count : count } hash
  field :votes, :type => Object, :default => {Negativity::VoteType::INSANE => 0,
                                              Negativity::VoteType::FOS => 0,
                                              Negativity::VoteType::TMI => 0}

  def self.vote(vote)
    vote = vote.symbolize_keys

    selector = {:item_id => vote[:item_id],
                :url => vote[:url]}
    update = {'$inc' => {"votes.#{vote[:vote_type]}" => 1}}

    self.collection.update(selector, update, {:upsert => true, :safe => true})
  end

end
