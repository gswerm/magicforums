class Topic < ApplicationRecord
  has_many :posts
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 20 }, presence: true
  paginates_per 6
  extend FriendlyId
  friendly_id :title, use: :slugged
end
