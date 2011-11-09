class Reviewer
  include Mongoid::Document

  field :reviewer_id, :type => String
  field :name, :type => String
  field :location, :type => String

  index :reviewer_id, :unique => true
  index :location, :unique => true

end
