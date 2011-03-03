class VotesController < ApplicationController

  respond_to :html, :json

  def review
    @vote = Vote.where(:review_id => params[:id]).first
    respond_with @vote
  end

  def item
    #I have the total available, create a compatible output
    item_id = params[:id]
    vote    = Vote.where(:item_id => item_id).first
    votes   = Counter.global(/item:#{item_id}:.*/, nil).inject({}) do |memo, record|
      memo[record.name.split(':')[2]] = record.count; memo
    end
    @vote   = {:item_id => item_id, :url => vote.url, :votes => votes}
    respond_with @vote
  end

  def reviewer
    #I have the total available, create a compatible output
    reviewer_id = params[:id]
    vote        = Vote.where(:reviewer_id => reviewer_id).first
    votes       = Counter.global(/reviewer:#{reviewer_id}:.*/, nil).inject({}) do |memo, record|
      memo[record.name.split(':')[2]] = record.count; memo
    end
    @vote       = {:reviewer_id => reviewer_id, :url => vote.url, :votes => votes}
    respond_with @vote
  end

  def batch
    #TODO
  end

  def create
    Vote.vote(params[:vote])
    render :nothing => true, :status => :created
  end

end
