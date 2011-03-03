class TotalController < ApplicationController

  respond_to :json

  def item
    @total   = total(:item, params[:id])
    respond_with @total
  end

  def reviewer
    @total       = total(:reviewer, params[:id])
    respond_with @total
  end

  private
  def total(field, id)
    vote    = Vote.where("#{field}_id" => id).first
    raise Negativity::NotFound "can'f find #{field} #{id}" if !vote
    votes   = Counter.global(/#{field}:#{id}:.*/, nil).inject({}) do |memo, record|
      memo[record.name.split(':')[2]] = record.count; memo
    end
    {"#{field}_id" => id, :url => vote.url, :votes => votes}
  end

end
