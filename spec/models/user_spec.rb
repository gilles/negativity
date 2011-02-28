require 'spec_helper'

describe User do

  it "should have an anonymous user" do
    User.anonymous.should_not be_nil
  end

end
