def factory_vote(options={})

  defaults = {:user_id => User.anonymous.id,
             :item_id => '1',
             :url => 'http://url',
             :review_id => '1',
             :reviewer_id => '1',
             :vote_type => Negativity::VoteType::INSANE}

  opts = defaults.merge(options)
  Review.vote(opts)
end
