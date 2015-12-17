class StaticPagesController < ApplicationController
	def home
		user = current_user
		if user
			ids = user.friends.collect { |f| f.id}
			ids << user.id
			posts = Post.where(user_id: ids).order(created_at: :desc)
			@timeline = posts.paginate(page: params[:page], per_page: 10)
		end
	end
end
