class LeaderboardController < ApplicationController

  def places
    @tmis = Item.order_by('votes.tmi').limit(10).to_a
    @foss = Item.order_by('votes.fos').limit(10).to_a
    @inss = Item.order_by('votes.ins').limit(10).to_a
  end

  def reviews
    @tmis = Review.where('votes.tmi' => {'$gt' => 0}).order_by('votes.tmi').limit(10).to_a
    @foss = Review.where('votes.fos' => {'$gt' => 0}).order_by('votes.fos').limit(10).to_a
    @inss = Review.where('votes.ins' => {'$gt' => 0}).order_by('votes.ins').limit(10).to_a
  end

end
