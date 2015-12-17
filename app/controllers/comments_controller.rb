class CommentsController < ApplicationController 
	before_action :authenticate_user!
	before_action :check_if_currently_friends, only: [:create]
	before_action(only: [:destroy, :edit, :update]) {|c| check_if_owner_is_current_user Comment}


	def create
		store_location
		@comment = Comment.new(comment_params)
		if @comment.save
			return_back_or_to_default
		else
			flash[:warning] = "Please try again."
			return_back_or_to_default
		end
	end

	def edit
		store_location
		@comment = Comment.find_by(id: params[:id])
	end

	def update
		@comment = Comment.find_by(id: params[:id])
		if @comment.update_attributes(comment_params)
			flash[:success] = "Comment Updated!"
			return_back_or_to_default
		else
			flash[:warning] = "Please fix the issues with the comment"
			render 'edit'
		end
	end

	def destroy
		store_location
		@comment = Comment.find_by(id: params[:id])
		@comment.destroy
		return_back_or_to_default
	end

	private

   	def check_if_currently_friends
   		id = params[:comment][:post_id]
   		post = Post.find_by(id: id) 
   		friend = post.user

		relationship = friendship_status(friend)
		if relationship != :friend and relationship != :self
			redirect_to root_path			
		end				
	end




	def comment_params
		params.require(:comment).permit(:body, :user_id, :post_id)
	end

end
