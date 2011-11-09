module Negativity
  module VoteType
    #insane
    INSANE = 'ins'
    #Full of shit
    FOS    = 'fos'
    #Full of shit
    TMI    = 'tmi'

    #for mongoid
    def self.get(value)
      value
    end

    #for mongoid
    def self.set(value)
      value
    end
  end
end
