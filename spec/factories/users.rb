Factory.define :user do |f|
  f.sequence(:name) {|n| "name#{n}" }
end