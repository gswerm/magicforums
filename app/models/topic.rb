class Topic < ApplicationRecord
  has_many :posts
  validates :title, length: { minimum: 3 }, presence: true
  validates :description, length: { minimum: 10 }, presence: true
  paginates_per 6
  extend FriendlyId
  friendly_id :title, use: :slugged
end
