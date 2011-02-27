# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)
Vote.create!(:url => 'http://www.google.com', :review_id => 1, :reviewer_id => 1, :vote => Vote::VoteType::BULLSHIT)
Vote.create!(:url => 'http://www.google.com', :review_id => 1, :reviewer_id => 2, :vote => Vote::VoteType::IDIOT)