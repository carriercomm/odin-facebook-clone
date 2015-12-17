require 'rails_helper'

describe Friendship do
	let(:user) do 
		user = FactoryGirl.create(:user)
	end

	let(:friend) do
		friend = FactoryGirl.create(:user)
	end

	let(:friendship) do
		described_class.create!(user_id: user.id, friend_id: friend.id)
	end

	it 'creates a friendship' do
		expect{friendship}.to change{described_class.all.count}.by(1)
	end	

	it 'does not allow for duplicate friendships' do
		user.friend_requests.create( friend_id: friend.id)
		expect{user.friend_requests.create( friend_id: friend.id)}.to change{described_class.all.count}.by(0)

	end

	it 'deletes friendship with delete_friendship' do
		friendship = user.friend_requests.create( friend_id: friend.id)
		expect{friendship.delete}.to change{described_class.all.count}.by(-1)
	end

end