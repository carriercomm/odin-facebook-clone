class Post < ActiveRecord::Base
	validates :body, presence: true
	validates :user_id, presence: true
	belongs_to :user, inverse_of: :posts
	has_many :likes, as: :likeable, dependent: :destroy 
	has_many :comments, dependent: :destroy 

	has_attached_file :picture, 
	                  styles: {:large => "800x800>",:medium => "500x500>", :thumb => "200x200>"}
	validates_attachment :picture, content_type:  { content_type: /\Aimage\/.*\Z/ },
													size: { in: 0..1.megabytes }

end
