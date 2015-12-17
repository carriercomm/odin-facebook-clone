require 'rails_helper'

describe Like do

	let(:user) do
		user = instance_double('User')
		expect(user).to receive(:id).and_return(5)
		user
	end

	let(:post) do
		post = instance_double('Post')
		expect(post).to receive(:id).and_return(5)
		post
	end
	let (:valid_like) {described_class.create(user_id: user.id, likeable_id: post.id, likeable_type: post.class)}

	it 'creates a like' do
		expect{valid_like.save}.to change{described_class.all.count}.by(1)
	end	



end