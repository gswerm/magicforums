class Comment < ApplicationRecord
  belongs_to :post
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 20 }, presence: true
  belongs_to :user
  enum role: [:user, :moderator, :admin]
  paginates_per 6
  has_many :votes

  def total_votes
    votes.pluck(:value).sum
  end

# Vote.where(comment_id: comment_id).sum(:value)
end
