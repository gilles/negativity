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
    @vote = Vote.new(params[:vote])
    flash['notice'] = "Vote created" if @vote.save
    respond_with @vote, :location => votes_url
  end

end
