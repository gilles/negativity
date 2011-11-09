class VotesController < ApplicationController

  before_filter :page

  respond_to :html, :except => :batch
  respond_to :json

  # get one review
  def review
    @vote = Review.where(:review_id => params[:id]).first
    respond_with @vote
  end

  # get all the reviews for a given item
  def item
    @votes    = Review.where(:item_id => params[:id]).skip(@skip).limit(@limit)
    respond_with @votes
  end

  # get all the reviews for a given person
  def reviewer
    @votes    = Review.where(:reviewer_id => params[:id]).skip(@skip).limit(@limit)
    respond_with @votes
  end

  def batch
    @votes = Review.where({:review_id.in => params[:reviewIds]}).only(:review_id, :votes).to_a
    #don't use respond_with, this is a post that does not a create anything, the default responder does not like this
    render :json => @votes.to_json
  end

  def create
    status = :created
    message = {:review_id => params[:vote][:review_id], :vote_type => params[:vote][:vote_type]}

    vote = params[:vote]
    if !self.authorized?(vote)
      status = :bad_request
      render :json => message, :status => status and return
    end

    begin
      Review.vote(vote)
      Item.vote(vote)
      Reviewer.create(params[:reviewer]) if params[:reviewer]
    rescue StandardError => e
      Rails.logger.error(e)
      #not really but it's an error code...
      status = :bad_request
      message[:error] = {:message => e.to_s}
    end
    render :json => message, :status => status
  end

  private
  def page
    @start = params[:start] || 0
    @limit = params[:limit] || 10
  end

  def authorized?(vote)

    #you can revote if you renew the session...
    key = vote[:user_id].to_s
    if key.blank?
      key = session_id
    end

    key += ":#{vote[:item_id]}"

    if Rails.cache.exist?(key)
      return false
    end

    Rails.cache.write(key, "1")

  end

end
