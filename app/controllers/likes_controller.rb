class LikesController < ApplicationController
	before_action :authenticate_user!
	before_action :check_if_currently_friends
	before_action(only: [:destroy]) {|c| check_if_owner_is_current_user Like}

	def create
		store_location
		like = Like.new(like_params)
		like.save
		return_back_or_to_default
		
	end

	def destroy
		store_location
		like = Like.find_by(id: params[:id])
		if like 
			like.delete
		end
		return_back_or_to_default
	end

	private

   	def check_if_currently_friends
   		if params[:like] and params[:like][:likeable_id]
   			id = params[:like][:likeable_id]
   			type = params[:like][:likeable_type]

   		else
   			like = Like.find(params[:id])
   			type = like.likeable_type
   			id = like.likeable_id
   		end
   		if type == "Post"
   			post = Post.find_by(id: id)
   			friend = post.user
   		else
   			comment = Comment.find_by(id: id)
   			friend = comment.user

   		end

		relationship = friendship_status(friend)
		if relationship != :friend and relationship != :self
			#return false
			redirect_to root_path			
		end				
	end

	def like_params
		params.require(:like).permit(:user_id, :likeable_id, :likeable_type)
	end

end