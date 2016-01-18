class PostsController < ApplicationController
	before_action :authenticate_user!
	before_action :check_if_friends, only: [:show]

	def show
		@post = Post.find_by(id: params[:id])
		@user = @post.user
		@comment = Comment.new(user_id: current_user.id, post_id: @post.id)

	end

	def new
		@user = current_user
		@post = @user.posts.build
	end

	def create
		@post = current_user.posts.build(post_params)
		if @post.save
			redirect_to user_post_path(@post.user, @post)

		else
			flash[:warning] = "Please correct errors."
			render 'new'
		end
	end

	def edit
		@post = Post.find_by(:id => params[:id])
	end

	def update
		@post = Post.find_by(:id => params[:id])
		if @post.update_attributes(post_params)
			flash[:success] = "Post successfully updated!"
			redirect_to user_post_path(@post.user, @post)
		else
			render 'edit'
		end
	end

	def destroy
		@post = Post.find_by(id: params[:id])
		@post.destroy
		redirect_to root_path
		
	end

	private

	def post_params
		params.require(:post).permit(:body, :user_id, :picture)
	end

end
