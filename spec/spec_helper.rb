# frozen_string_literal: true

require 'rescoped'
require 'factory_bot'
require File.expand_path('support/models.rb', __dir__)
require File.expand_path('support/shared_examples.rb', __dir__)

database = File.join(File.dirname(__FILE__), '/rescoped.sqlite3')
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)

load File.expand_path('support/schema.rb', __dir__)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
