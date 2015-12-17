require 'rails_helper'

describe Post do 

	let(:user) do
		user = instance_double('User')
		expect(user).to receive(:id).and_return(1)
		user
	end

	let(:body_copy) {"Some text goes here."}

	let(:valid_post) do
		described_class.create!(body: body_copy , user_id: user.id)
	end

	it 'creates a post' do
		expect{valid_post}.to change { described_class.all.count }.by(1)	
	end

	it 'will not allow missing user' do
		post = described_class.new(body: "Test copy")
		expect(post.valid?).to eq(false)
	end

	it 'will not allow missing body' do
		post = described_class.new(user_id: user.id)
		expect(post.valid?).to eq(false)
	end

	it 'is valid with a body and user' do
		expect(valid_post).to be_valid
	end

	it 'has body text' do
		expect(valid_post.body).to eq(body_copy)
	end

end


