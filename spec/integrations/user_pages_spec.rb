require 'rails_helper'

describe 'User pages' do

	context 'show' do
		before :each do
			@user = FactoryGirl.create(:user_with_friends_requests_requested)
			login_as_user(@user)
		end

		it 'should show your name, gravatar and description' do
			visit user_path @user
			gravatar_id = Digest::MD5::hexdigest(@user.email.downcase)
			size = 50
			expect(page).to have_content(@user.name)
			expect(page).to have_selector('.user-bio')
			expect(page).to have_selector('.gravatar') do |div|
				expect(div).to have_selector("img", :src => "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}")
			end
		end

		it "shows edit link if it is your profile" do
			visit user_path @user
			expect(page).to have_link("Edit Profile", settings_path)
		end

		it "displays unfriend button if visiting friend" do 
			friend = @user.friends[0]
			visit user_path friend
			expect(page).to have_selector('.defriend')
		end

		it "displays confirm and decline buttons if user has requested to be friends" do
			requestor = @user.friend_requests[0].user
			visit user_path requestor
			expect(page).to have_selector('.confirm-request')
			expect(page).to have_selector('.decline-request')
		end

		it "displays correct text if friend request has been sent" do
			requested = @user.requested_friends[0].friend
			visit user_path requested
			expect(page).to have_content('Friend Request Sent')
		end


		it "displays request friend button if user is not requested or a friend" do
			other_user = FactoryGirl.create(:user)
			visit user_path other_user
			expect(page).to have_selector('.friend-request')
		end

		it "lists a freinds recent posts" do
			friend = @user.friends[0]
			visit user_path friend
			expect(page).to have_content(friend.posts[0].body)
			expect(page).to have_link("View Post", user_post_path( friend, friend.posts[0]))
		end

		it "does not list a non-friend's recent posts" do
			other_user = FactoryGirl.create(:user_with_posts)
			visit user_path other_user
			expect(page).to_not have_content(other_user.posts[0].body)
		end

	end	

	context 'index' do
		before :each do
		 	@user = FactoryGirl.create(:user_with_friends_requests_requested)
		 	@friends = @user.friends
			@users = FactoryGirl.create_list(:user, 4)
		 	login_as_user(@user)
			visit users_path
		end

		it "lists all users" do
			@users.each do |user| 
				expect(page).to have_content(user.name)
				expect(page).to have_link(user.name, user_path(user))
			end
			@friends.each do |friend| 
				expect(page).to have_content(friend.name)
			end
		end
		it "shows request link if not a friend" do
			expect(page).to have_css('div.friend-request')
		end

		it "shows that you are a friend if a friend" do
			expect(page).to have_css('div.friends')
		end
		it "shows that you requested to be their friend" do
			expect(page).to have_css('div.requested')
		end
		it "shows that they requested to be your friend" do
			expect(page).to have_css('div.awaiting')
		end
	end

end
