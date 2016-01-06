require 'rails_helper'

describe 'Home Page' do

	context "not logged in" do
		before :each do
			 visit root_path 
		end		
		it "loads the homepage" do
			expect(page).to have_content("Facebook_Cl0ne")
		end		
		it "has the login and register links" do
			expect(page).to have_link("Login", :href => login_path)
			expect(page).to have_link("Register", :href => new_user_registration_path)
		end

		it "has introductory text" do
			expect(page).to have_content("Welcome")

		end

	end

	context "logged in" do
		before :each do
			@user = FactoryGirl.create(:user_with_friends_requests_requested)
			login_as_user(@user)
			visit root_path 
		end
		it "has the logout link" do
			expect(page).to have_link("Logout", :href => logout_path)

		end
		it "has the path to the user profile" do
			expect(page).to have_link("Profile", :href => user_path(@user))

		end		
		it "has the path to create a post" do
			expect(page).to have_link("Possble Friends", :href => users_path)

		end
		it "has the path to see all friends" do
			expect(page).to have_link("Friends", :href => friends_path)

		end
		it "has the path to see all friend requests" do
			expect(page).to have_link("Friend Requests", :href => friend_requests_path)
		end

		it "shows the number of friend requests awaiting on link" do
			expect(page).to have_link("Friend Requests (#{@user.friend_requests.length})", :href => friend_requests_path)
		end

	context "timeline" do

		before :each do 
			@user  = FactoryGirl.create(:user_and_friends_posts_comments_likes)
			login_as_user(@user)
			visit root_path
			@post = @user.posts[0]
		end
		it "shows the user's posts" do
			posts = @user.posts
			posts.each do |post|
				expect(page).to have_content(post.body)
			end
		end

		it "shows post images" do 
			post = FactoryGirl.create(:post_with_picture, user_id: @user.id)
			visit root_path
			expect(page).to have_css("img[src*='#{post.picture.url(:thumb)}']")

		end

		it "shows link to view post" do
			posts = @user.posts
			posts.each do |post|
				expect(page).to have_link("View Post", user_post_path(post.user, post))
			end			
		end

		it "contains user's name and profile picture" do
			expect(page).to have_link(@user.name, user_path(@user))
			expect(page).to have_css("img[src*='#{@user.profile_picture.url(:thumb)}']")				
		end

		it "contains number of likes and links to like" do
			likes_text = @post.likes.count == 1 ? "#{@post.likes.count} Like" : "#{@post.likes.count} Likes"
			expect(page).to have_content(likes_text)
			expect(page).to have_link("Like", likes_path)			
		end

		it "contains number of comments and comment button to post show" do
			comments_text = @post.comments.count == 1 ? "#{@post.comments.count} Comment" : "#{@post.comments.count} Comments"
			expect(page).to have_content(comments_text)
			expect(page).to have_link("Comment", user_post_path(@post.user, @post))
		end

		it "shows friend's posts" do
			friends = @user.friends
			friends.each do |friend|
				posts = friend.posts
					posts.each do |post|
						expect(page).to have_content(post.body)
					end
			end
		end
	end

	end

end