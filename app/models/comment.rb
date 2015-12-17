class Comment < ActiveRecord::Base
	validates :body, presence: true
	validates :user_id, presence: true
	validates :post_id, presence: true	
	belongs_to :user, inverse_of: :comments
	belongs_to :post, inverse_of: :comments
	has_many :likes, as: :likeable, dependent: :destroy

end
