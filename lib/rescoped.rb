# frozen_string_literal: true

require 'active_support/lazy_load_hooks'
require 'active_record'
require 'rescoped/query_methods'

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Relation.include(Rescoped::QueryMethods)
end
