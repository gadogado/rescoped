# frozen_string_literal: true

RSpec.shared_examples 'rescoped relation' do
  it 'returns an active_record relation' do
    expect(scope).to be_kind_of(ActiveRecord::Relation)
  end
end

RSpec.shared_examples 'not destructive' do |query_method, relation|
  # Example:
  #   expect(
  #     scope
  #       .remove_includes(:regions)
  #       .includes(:regions)
  #       .values[:includes]
  #   ).to include(:regions)

  it 'is not destructive and can be added again if removed' do
    expect(
      scope
        .send("remove_#{query_method}", relation)
        .send(query_method, relation)
        .values[query_method.to_sym]
    ).to include(relation)
  end
end
