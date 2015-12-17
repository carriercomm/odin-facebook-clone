require 'rails_helper'


describe "Friendship pages" do 

	before :each do
	 	@user = FactoryGirl.create(:user_with_friends)
	 	@friends = @user.friends
	 	@second_user = FactoryGirl.create(:user_with_friends_requests_requested)
	 	@friend_requests = @second_user.friend_requests
	 end

	context "index" do
		before :each  do
		 	login_as_user(@user)
			visit friends_path
		end

		it "index should show each friend" do
			@friends.each do |friend|
				expect(page).to have_content(friend.name)
				expect(page).to have_link(friend.name, user_path(friend))
			end
		end
		it "friend should have a defriend box" do
			expect(page).to have_css('div.defriend')
		end

	end

	context "friend_requests" do
		before :each do
		 	login_as_user(@second_user)
			visit friend_requests_path
		end
		it "friend request should show each friend request" do
			@friend_requests.each do |request|
				expect(page).to have_content(request.user.name)
			end
		end
		it "friend request should have a confirm box" do
			expect(page).to have_css('div.confirm-request')
		end
		it "friend request should have a decline box" do
			expect(page).to have_css('div.decline-request')
		end
	end
end