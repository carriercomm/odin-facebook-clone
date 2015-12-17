module UsersHelper
	def gravatar_for(user, options = { size: 80 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class:"gravatar")
	end	
	
    def friendship_status(user)
	   if current_user.friends.include?(user)
	   		:friend
	   elsif current_user.friend_request_users.include?(user) 
	   		:awaiting
	   elsif current_user.requested_friend_users.include?(user)
	   		:requested 
	   elsif current_user == user
	   		:self
	   else
	   		:not_friend
	   end     	
    end

   	def check_if_friends
		friend = User.find_by(id: params[:user_id])
		relationship = friendship_status(friend)
		if relationship != :friend and relationship != :self
			redirect_to root_path			
		end				
	end

end
