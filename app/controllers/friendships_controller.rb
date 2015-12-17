class FriendshipsController < ApplicationController
	before_action :authenticate_user!
	
	def index
		@friends = current_user.friends.paginate(page: params[:page])
	end

	def create
		Friendship.create(user_id: params[:user_id], friend_id: params[:friend_id])
		redirect_to root_url
	end

	def destroy
		friendship = Friendship.find(params[:id])
		friendship.delete
		redirect_to root_url
	end

	def friend_requests
		@friend_requests = current_user.friend_requests
	end

	def confirm_request
		@friend_request = Friendship.find(params[:id])
		@friend_request.confirm
		redirect_to friend_requests_url
	end

end
