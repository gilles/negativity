class VotesController < ApplicationController

  respond_to :html, :js, :json

  def index
    @votes = Vote.all.limit(30)
    respond_with @votes
  end

  def show
    @vote = Vote.find(params[:id])
    respond_with @vote
  end

  def create
    p = params[:vote]
    @vote = Vote.vote(p[:user_id], p[:url], p[:item_id], p[:reviewer_id], p[:vote_type])
    flash['notice'] = "Vote created" if @vote.save
    respond_with @vote, :location => votes_url
  end

end
