require 'rails_helper'

describe "Data Associations" do 
	before :each do
		@user = User.create!(name: "Xerxes", email: "xerxes@home.com", password: "crabface")
		@second_user = User.create!(name:"Mao", email: "mao@homes.com", password:"crabface")
		@third_user = User.create!(name:"Beast", email: "beast@homes.com", password:"crabface")		
		@fourth_user = User.create!(name:"hochi", email: "hochi@homes.com", password:"crabface")		
		@post1 = Post.create!(body: "Body Copy Goes here!", user_id: @user.id)
		@post1_like = @post1.likes.create!(user_id: @post1.user_id )
		@post2 = Post.create!(body: "Body Copy Goes here!", user_id: @user.id)
		@post2_like = @post2.likes.create!(user_id: @post2.user_id )
		@comment1 = @post1.comments.create!(user_id: @second_user.id, body: "Test text")
		@comment2 = @post2.comments.create!(user_id: @user.id, body: "Test text")
		@comment1_like = @comment1.likes.create!(user_id: @second_user.id)
		@comment2_like = @comment2.likes.create!(user_id: @second_user.id)
		@friend_request_1 = @user.requested_friends.create!(friend_id: @second_user.id)
		@friend_request_2 = @user.requested_friends.create!(friend_id: @third_user.id)
		@friend_request_3 = @fourth_user.requested_friends.create!(friend_id: @user.id)

	end		

	context "User Associations with likes, posts and comments" do

		it "allows for collection of posts through associations" do
			posts = @user.posts
			expect(posts.length).to eq(2)
			expect(posts[0].class).to eq(Post)
		end

		it 'allows for building of post through user' do
			post = @user.posts.create!(body: "Third Body Copy Attempt")
			expect(post).to be_valid
			expect(post.class).to eq(Post)
		end
		it 'gets all likes of user' do
			expect(@user.likes.count).to eq(2)
		end

		it 'gets all posts of user' do
			expect(@user.posts.count).to eq(2)
		end
		it 'gets all comments of user' do
			expect(@user.comments.count).to eq(1)
		end
		it 'only allows for one like' do
			invalid_like = @post1.likes.new(user_id: @post1.user_id)
			expect(invalid_like.save).to eq(false)
		end
		it 'gets all friend requests' do 
		 	expect(@user.friend_requests.length).to eq(1)
		end
		
		it 'gets all requested friends' do 
		 	expect(@user.requested_friends.length).to eq(2)
		end

		it 'changing request status count' do
			expect{@friend_request_1.confirm}.to change{@user.requested_friends.count}.by(-1)
		end

		it 'user deletion deletes all posts, likes and comments of user' do
			posts = @user.posts.collect{|post| post.id}
			comments = Comment.where("user_id = ? OR post_id in (?) ", @user.id,  posts).collect{|comment| comment.id}
			likes = Like.where("user_id = ? OR likeable_id in (?) ", @user.id,  posts + comments).collect{|like| like.id}
		
			expect{@user.destroy!}.to change{Like.count}.by(-likes.length).and change{Comment.count}.by(-comments.length)
				.and change{Post.count}.by(-posts.length)
		end

		

	end

	context "post data associations" do

		it 'gets all comments of post and comment relates to post' do
			expect(@post1.comments.count).to eq(1)
			expect(@post1.comments[0].post).to eq(@post1)
		end

		it 'gets all like of post and like relates to post' do
			expect(@post1.likes.count).to eq(1)
			expect(@post1.likes[0].likeable).to eq(@post1)

		end
		it 'belongs to user' do
			expect(@post1.user.class).to eq(User)
		end		

		it 'post deletion deletes likes and comments and comment\'s likes but not user' do
			comments = @post1.comments.collect{|comment| comment.id}
			likes = Like.where("likeable_id in (?) ", [@post1.id] + comments).collect{|like| like.id}
			expect{@post1.destroy!}.to change{Like.count}.by(-likes.length).and change{Comment.count}.by(-comments.length)
				 .and change{User.count}.by(0)
		
		end
	end
	context "comment data associations" do

		it 'gets all like of comment and like relates to comment' do
			expect(@comment1.likes.count).to eq(1)
			expect(@comment1.likes[0].likeable).to eq(@comment1)

		end
		it 'belongs to a user' do
			expect(@comment1.user.class).to eq(User)
		end

		it 'belongs to a post' do
			expect(@comment1.post.class).to eq(Post)
		end
		it 'comment deletion deletes comment and comment\'s likes but not user' do
			likes = @comment1.likes
			expect{@comment1.destroy!}.to change{Like.count}.by(-likes.length).and change{User.count}.by(0).and change{Post.count}.by(0)
		
		end
	end

end

