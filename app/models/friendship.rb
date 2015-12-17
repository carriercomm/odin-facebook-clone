class Friendship < ActiveRecord::Base
	validates_uniqueness_of :user_id, :scope => :friend_id
	belongs_to :user, class_name: 'User'
	belongs_to :friend, class_name: "User"
	
	def confirm
		self.request_status = "confirmed"
		self.save
	end


end
