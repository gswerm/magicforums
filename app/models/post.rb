class Post < ApplicationRecord
  has_many :comments
  belongs_to :topic
  mount_uploader :image, ImageUploader
  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  belongs_to :user
  paginates_per 6

  extend FriendlyId
  friendly_id :title, use: :slugged

end
