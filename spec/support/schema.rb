# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :photos, force: true do |t|
    t.references :user, index: false
    t.references :region, index: false
  end

  create_table :users, force: true do |t|
    t.string :full_name
    t.references :region, index: false
  end

  create_table :regions, force: true do |t|
    t.string :name
  end
end
