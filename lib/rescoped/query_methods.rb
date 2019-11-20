# frozen_string_literal: true

require 'active_record/relation'
require 'rescoped/error'

module Rescoped
  module QueryMethods # :nodoc:
    SUPPORTED_QUERY_METHODS = %i[joins left_outer_joins includes].freeze

    # @!method remove_joins(*args)
    # Removes any number of joins relations in scope
    #
    # @param args [Array<Symbol>] associations to remove
    # @return [ActiveRecord::Relation]
    # @example
    #   Model.joins(:a, :b, :c).remove_joins(:a, :b)

    # @!method remove_left_outer_joins(*args)
    # Removes any number of left outer joins relations in scope
    #
    # @param args [Array<Symbol>] associations to remove
    # @return [ActiveRecord::Relation]
    # @example
    #   Model.left_joins(:a, :b, :c).remove_left_outer_joins(:b)

    # @!method remove_includes(*args)
    # Removes any number of eager loaded relations in scope
    #
    # @param args [Array<Symbol>] associations to remove
    # @return [ActiveRecord::Relation]
    # @example
    #   Model.includes(:a, :b, :c).remove_includes(:a)

    SUPPORTED_QUERY_METHODS.each do |name|
      define_method("remove_#{name}") do |*args|
        rescoped(query_method: name, relations: args)
      end
    end

    private

    # @param query_method [Symbol] ActiveRecord::QueryMethods method name
    # @param relations [Array<Symbol>] relations to remove
    # @raise [Rescoped::Error::UNSUPPORTED_QUERY_METHOD]
    #   if query_method is unsupported

    def rescoped(query_method:, relations: [])
      unless SUPPORTED_QUERY_METHODS.include?(query_method)
        raise Rescoped::Error::UNSUPPORTED_QUERY_METHOD
      end

      new_relations = values.fetch(query_method, []) - relations
      new_values    = values.merge(query_method => new_relations)
      klass         = @klass || self

      ActiveRecord::Relation.new(klass, values: new_values)
    end
  end
end
