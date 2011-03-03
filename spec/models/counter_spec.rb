require 'spec_helper'

describe Counter do

  before(:each) do
    Counter.increment(:stuff)
  end

  Counter::INTERVALS.each do |interval|
    it "should increment #{interval}" do
      c = Counter.where(:name => :stuff, :time => Counter.send("#{interval}_key".to_sym)).one
      #yes, will fail if the test is in between hour... now compute the probability of that
      c.count.should == 1
    end
  end

  Counter::INTERVALS.each do |interval|
    it "should respond to #{interval} scope" do
      c = Counter.send(interval, :stuff, Time.now.utc).one
      c.should be_is_a(Counter)
    end
  end

end
