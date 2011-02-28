class User
  include Mongoid::Document

  field :name, :type => String

  index :name, :unique => true

  def self.anonymous
    where(:name => 'anonymous').first
  end

end
