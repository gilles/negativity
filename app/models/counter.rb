#used for trends when no mapreduce grouping
class Counter
  include Mongoid::Document

  INTERVALS = [:daily, :global]

  field :name
  field :time, :type => Time
  field :count, :type => Integer

  index(
    [
      [ :name, Mongo::ASCENDING ],
      [ :time, Mongo::DESCENDING ]
    ]
  )

  INTERVALS.each do |interval|
    scope interval, lambda { |name, time| {:where => {:name => name, :time => Counter.send("#{interval}_key".to_sym, time)}} }
  end

  #pro of this: constant size objects
  #cons of this: several requests for update
  
  class << self

    def increment(name, count=1)
      time = Time.now.utc
      INTERVALS.each do |interval|
        condition  = {:name => name, :time => Counter.send("#{interval}_key".to_sym, time)}
        increments = {'$inc' => {:count => count}}
        collection.update(condition, increments, :upsert => true)
      end
    end

    private

    #the minute is here so monthly[january] does not tramp yearly (for example)

    def hourly_key(t=Time.now.utc)
      Time.utc(t.year, t.month, t.mday, t.hour, 1, 0)
    end

    def daily_key(t=Time.now.utc)
      Time.utc(t.year, t.month, t.mday, 0, 2, 0)
    end

    def monthly_key(t=Time.now.utc)
      Time.utc(t.year, t.month, 1, 0, 3, 0)
    end

    def yearly_key(t=Time.now.utc)
      Time.utc(t.year, 1, 1, 0, 4, 0)
    end

    def global_key(t=Time.now.utc)
      Time.utc(1970, 1, 1, 0, 5, 0)
    end
  end

end
