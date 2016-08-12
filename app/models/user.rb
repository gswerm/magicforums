class User < ApplicationRecord
 has_many :topics
 has_many :posts
 has_many :comments
 has_secure_password
 validates :email, uniqueness: true
 enum role: [:user, :moderator, :admin]
end
