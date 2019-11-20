# frozen_string_literal: true

require 'spec_helper'

describe 'remove_includes' do
  let(:scope) { Photo.includes(:region, :user) }

  include_examples 'rescoped relation'
  include_examples 'not destructive', 'includes', :regions

  it 'removes a single included relation but keeps the remaining ones' do
    included_relations = scope.remove_includes(:region).values[:includes]

    expect(included_relations).to_not include(:region)
    expect(included_relations).to_not be_empty
  end

  it 'removes multiple relations that have been included' do
    expect(scope.remove_includes(:region, :user).values[:includes]).to be_empty
  end

  it 'does not modify joins or left_outer_joins' do
    scope_with_other_query_methods = scope
                                     .joins(:regions)
                                     .left_outer_joins(:users)
                                     .remove_includes(:region, :user)

    relation_values = scope_with_other_query_methods.values
    expect(relation_values[:left_outer_joins]).to eq([:users])
    expect(relation_values[:joins]).to eq([:regions])
  end

  it 'does not include generated sql from an includes' do
    included_sql = 'LEFT OUTER JOIN "regions" ON "regions"."id"'

    scope = Photo.includes(:region).where(regions: { name: 'SE Portland' })
    expect(scope.to_sql).to include(included_sql)

    expect(
      scope.remove_includes(:region).to_sql
    ).to_not include(included_sql)
  end
end

describe 'remove_joins' do
  let(:scope) { User.joins(:photos, :region) }

  include_examples 'rescoped relation'
  include_examples 'not destructive', 'joins', :photos

  it 'removes a single joins relation but keeps the remaining ones' do
    joins_relations = scope.remove_joins(:photos).values[:joins]
    expect(joins_relations).to_not include(:photos)
    expect(joins_relations).to_not be_empty
  end

  it 'removes multiple joins relations' do
    expect(scope.remove_joins(:photos, :region).values[:joins]).to be_empty
  end

  it 'does not modify includes or left_outer_joins' do
    scope_with_other_query_methods = scope
                                     .includes(:regions)
                                     .left_outer_joins(:photos)
                                     .remove_joins(:photos, :region)

    relation_values = scope_with_other_query_methods.values
    expect(relation_values[:left_outer_joins]).to eq([:photos])
    expect(relation_values[:includes]).to eq([:regions])
  end

  it 'does not include removed joins relation in sql query' do
    removed_sql = scope.remove_joins(:photos).to_sql

    expect(removed_sql).to_not include('INNER JOIN "photos"')
    expect(removed_sql).to include('INNER JOIN "regions"')
  end
end

describe 'remove_left_outer_joins' do
  let(:scope) { User.left_outer_joins(:photos, :region) }

  include_examples 'rescoped relation'
  include_examples 'not destructive', 'left_outer_joins', :photos

  it 'removes a single left_outer_joins relation but keeps the remaining ones' do
    left_outer_joins_relations = scope.remove_left_outer_joins(:photos).values[:left_outer_joins]

    expect(left_outer_joins_relations).to_not include(:photos)
    expect(left_outer_joins_relations).to_not be_empty
  end

  it 'removes multiple joins relations' do
    expect(scope.remove_left_outer_joins(:photos, :region).values[:left_outer_joins]).to be_empty
  end

  it 'does not modify includes or joins' do
    scope_with_other_query_methods = scope
                                     .includes(:regions)
                                     .joins(:photos)
                                     .remove_left_outer_joins(:photos, :region)

    relation_values = scope_with_other_query_methods.values
    expect(relation_values[:joins]).to eq([:photos])
    expect(relation_values[:includes]).to eq([:regions])
    expect(relation_values[:left_outer_joins]).to be_empty
  end

  it 'does not include removed left_outer_joins relation in sql query' do
    removed_sql = scope.remove_left_outer_joins(:region).to_sql

    expect(removed_sql).to include('LEFT OUTER JOIN "photos"')
    expect(removed_sql).to_not include('LEFT OUTER JOIN "regions"')
  end
end
