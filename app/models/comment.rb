class Comment < ApplicationRecord
  belongs_to :post
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 20 }, presence: true
  belongs_to :user
  enum role: [:user, :moderator, :admin]
  paginates_per 6
end