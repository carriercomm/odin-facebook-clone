require 'rails_helper'

describe FriendshipsController do

	before :each do
		@user = FactoryGirl.create(:user)
		@users = FactoryGirl.create(:user_with_friends)
		@friend_to_be = FactoryGirl.create(:user)
	end

	context 'not logged in' do

		before :each do
			sign_in nil
		end

		it "redirects index to login" do
			get :index
			expect(response).to redirect_to(new_user_session_path)
		end
	end

	context 'logged in' do 
		before :each do
			sign_in @user
		end

		it "renders index template" do
			get :index
			expect(response).to render_template :index
		end

		it "creates a friendship" do
			expect{
					post :create, :user_id => @user.id, :friend_id => @friend_to_be.id
				}.to change{Friendship.count}.by(1)
		end

		it "destroys a friendship" do
			post :create, :user_id => @user.id, :friend_id => @friend_to_be.id
			friendship = Friendship.first
			expect{
					post :destroy, id: friendship.id
				}.to change{Friendship.count}.by(-1)

		end

	end

end