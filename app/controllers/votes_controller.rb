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
    Vote.vote(params[:user_id], params[:url], params[:item_id], params[:reviewer_id], params[:vote])
    respond_with @vote, :location => votes_url
  end

end
