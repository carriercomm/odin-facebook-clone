class UsersController < ApplicationController
	before_action :authenticate_user!, only: [:show]
	def show
		@user = User.find_by(id: params[:id])
	    redirect_to root_url and return unless @user.confirmed_at

	end
	def index
	    @users = User.where.not(:confirmed_at => nil).paginate(page: params[:page])
	end
	private


end
