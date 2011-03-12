require 'rubygems'
require 'spork'

Spork.prefork do

#  https://github.com/timcharper/spork/wiki/Spork.trap_method-Jujutsu
  ENV["RAILS_ENV"] ||= 'test'

  #trick for mongoid
  require "rails/mongoid"
  Spork.trap_class_method(Rails::Mongoid, :load_models)

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'factory_girl'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    config.mock_with :rspec

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation, {:except => %w[ system.indexes ]}
    end

    config.before(:each) do
      User.create!(:name => 'anonymous')
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

  end

end

Spork.each_run do
  Factory.definition_file_paths = [
          File.join(Rails.root, 'spec', 'factories')
  ]
  Factory.find_definitions
end
