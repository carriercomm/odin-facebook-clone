require 'rails_helper'

describe LikesController do

	before :each do 
		@user = FactoryGirl.create(:user_with_posts_likes)
		@post = @user.posts[0]
		@second_post = FactoryGirl.create(:post)
		@like = @user.likes[0]
		@second_like = FactoryGirl.create(:like, likeable_id: @post.id)
		@other_post = FactoryGirl.create(:post, user_id: @user.id)	
	end	

	context 'not logged in' do
		before :each do
			sign_in nil
		end

		it 'does not allow for creating while not logged in' do

			expect{
				post :create, :like => { user_id: @user, likeable_id: @post, likeable_type: @post.class.to_s}
			}.to change{Like.count}.by(0)
		end

		it 'does not allow for destroying while not logged in' do
			expect{
				post :destroy, id: @like
			}.to change{Like.count}.by(0)
		end
	end

	context 'logged in' do
		before :each do
			sign_in @user
		end
		
		it 'creates while logged in' do
			expect{
				post :create, :like => { user_id: @user, likeable_id: @other_post, likeable_type: @other_post.class.to_s}
			}.to change{Like.count}.by(1)
		end

		it 'deletes while logged in' do
			expect{
				post :destroy, id: @like
			}.to change{Like.count}.by(-1)
		end

		it "does not allow liking of non-friends posts" do
			expect{
				post :create, :like => { user_id: @user, likeable_id: @second_post, likeable_type: @post.class.to_s}
			}.to change{Like.count}.by(0)
		end

		it "only allows destruction if the liker is the current user" do
		expect{
				post :destroy, id: @second_like
			}.to change{Like.count}.by(0)
		end

	end
end