def factory_vote(options={})

  defaults = {:user_id => User.anonymous.id,
             :item_id => '1',
             :url => 'http://url',
             :review_id => '1',
             :reviewer_id => '1',
             :vote_type => Vote::VoteType::INSANE}

  opts = options.merge(defaults)
  Vote.vote(opts)
end
