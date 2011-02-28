# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :vote do |v|
  v.user_id { User.anonymous.id }
  v.url "http://url"
  v.item_id 1
  v.reviewer_id 1
  v.vote_type Vote::VoteType::INSANE
  v.votes 1
end
