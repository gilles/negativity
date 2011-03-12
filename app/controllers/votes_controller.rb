class VotesController < ApplicationController

  before_filter :page

  respond_to :html, :except => :batch
  respond_to :json

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
    @votes = Vote.where({:review_id.in => params[:reviewIds]}).to_a
    #don't use respond_with, this is a post that is not a create thing, the default responder does not like this
    render :json => @votes.to_json
  end

  def create
    status = :created
    message = {}
    begin
      Vote.vote(params[:vote])
    rescue StandardError => e
      #not really but it's an error code...
      status = :bad_request
      message = { :error => {:message => e.to_s}}
    end
    render :json => message, :status => status
  end

  private
  def page
    @start = params[:start] || 0
    @limit = params[:limit] || 10
  end

end
