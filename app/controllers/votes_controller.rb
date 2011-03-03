class VotesController < ApplicationController

  before_filter :page

  respond_to :html, :json

  def review
    @vote = Vote.where(:review_id => params[:id]).first
    respond_with @vote
  end

  def item
    @votes    = Vote.where(:item_id => params[:id]).skip(@skip).limit(@limit)
    respond_with @votes
  end

  def reviewer
    @votes    = Vote.where(:reviewer_id => params[:id]).skip(@skip).limit(@limit)
    respond_with @votes
  end

  def batch
    #TODO
  end

  def create
    Vote.vote(params[:vote])
    render :nothing => true, :status => :created
  end

  private
  def page
    @start = params[:start] || 0
    @limit = params[:limit] || 10
  end

end
