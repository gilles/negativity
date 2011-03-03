#register error for ShowExceptions middleware
ActionDispatch::ShowExceptions.rescue_responses['Mongoid::Errors::DocumentNotFound'] = :not_found
ActionDispatch::ShowExceptions.rescue_responses['Negativity::NotFound'] = :not_found