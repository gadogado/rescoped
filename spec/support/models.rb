# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Photo < ApplicationRecord
  belongs_to :user
  belongs_to :region
end

class Region < ApplicationRecord
  has_many :users
  has_many :photos
end

class User < ApplicationRecord
  belongs_to :region
  has_many :photos
end
