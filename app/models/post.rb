class Post < ActiveRecord::Base
	validates :body, presence: true
	validates :user_id, presence: true
	belongs_to :user, inverse_of: :posts
	has_many :likes, as: :likeable, dependent: :destroy 
	has_many :comments, dependent: :destroy 
end
