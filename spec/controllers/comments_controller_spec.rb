require 'rails_helper'

describe CommentsController do
	
	before :each do
		@user = FactoryGirl.create(:user_with_posts)
		@post = @user.posts[0]
		@comment = FactoryGirl.create(:comment, user: @user)
		@other_user = FactoryGirl.create(:user_with_comments)
		@other_comment = @other_user.comments[0]

	end

	describe "not logged in" do
		before :each do
			sign_in nil
		end

		it "does not allow for creation while not logged in" do
			expect{
				post :create,  comment: {user_id: @user, body: "Test body", post_id: @post} 
				}.to change{Comment.count}.by(0)
		end

	end

	describe "logged in" do
		before :each do
			sign_in @user
		end

		it "creates while logged in" do
			expect{
				post :create,  comment: {user_id: @user, body: "Test body", post_id: @post} 
				}.to change{Comment.count}.by(1)
		end

		it 'destroys while logged in' do
			expect{
				post :destroy, id: @comment
				}.to change{Comment.count}.by(-1)
		end

		it "updates a comment" do
			new_body = "New Body"
			put :update, :id => @comment , :comment => {:body => new_body}
			@comment.reload
			expect(@comment.body).to eq(new_body) 

		end

		it 'renders the edit view' do
			get :edit, id: @comment
			expect(response).to render_template :edit
		end

		context "a non-friend's post" do

			it "does not allow for the creation of a comment" do
				post = FactoryGirl.create(:post)
				expect{
					post(:create,  comment: {user_id: @user, body: "Test body", post_id: post}) 
					}.to change{Comment.count}.by(0)
			end
		end

		it "user can only delete own comments" do
			expect{
				post :destroy, id: @other_comment
				}.to change{Comment.count}.by(0)
		end

	end

end