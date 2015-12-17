require 'rails_helper' 

describe PostsController do

	before :each do
		@user = FactoryGirl.create(:user_with_friends_requests_requested)
		@post = @user.posts[0]
	end

	context "logged in" do
		before :each do
			sign_in @user
		end		

		it "renders the show template" do
			get :show, user_id: @user, id: @post
			expect(response).to render_template :show
		end
		it "renders the edit template" do
			get :edit, user_id: @user, id: @post
			expect(response).to render_template :edit
		end
		it "renders the new template" do
			get :new, user_id: @user
			expect(response).to render_template :new
		end	

		it "creates a new post" do
		    expect{
		    	post :create,  post: { :user_id => @user.id,:body => "Test parameters."}	
		    		}.to change{Post.count}.by(1)
		end

		it "updates a post" do
			new_body = "New Body"
			put :update, :id => @post , :post => {:body => new_body}
			@post.reload
			expect(@post.body).to eq(new_body) 

		end

		it "destroys a post" do
		    expect{
		    	post :destroy, :user_id => @user.id, id: @post.id	
		    		}.to change{Post.count}.by(-1)
			expect(response).to redirect_to(root_path)

		end

		it "show redirects when not a friend" do
			non_friend = FactoryGirl.create(:user_with_posts)
			post = non_friend.posts[0]
			get :show, user_id: non_friend, id: post
			expect(response).to redirect_to(root_path)
		end

	end

	context "not logged in" do
		before :each do
			sign_in nil			
		end	



		it "show redirects when not logged in" do
			get :show, user_id: @user, id: @post
			expect(response).to redirect_to(new_user_session_path)
		end

		it "new redirects when not logged in" do
			get :new, user_id: @user
			expect(response).to redirect_to(new_user_session_path)
		end

	end
	
end