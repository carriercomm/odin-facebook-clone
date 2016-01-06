require 'rails_helper'

describe Post do 
	include Paperclip::Shoulda::Matchers

	let(:user) { FactoryGirl.create(:user) }

	let(:body_copy) {"Some text goes here."}

	let(:valid_post) do
		described_class.new(body: body_copy , user_id: user.id)
	end

	it 'creates a post' do
		expect{valid_post.save}.to change { described_class.all.count }.by(1)	
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
	
	it { expect(valid_post).to_not validate_attachment_presence :picture }
	it { expect(valid_post).to validate_attachment_content_type(:picture).allowing(
	  'image/png', 'image/jpg', 'image/jpeg', 'image/gif'
	).rejecting(
	  'text/plain', 'text/html', 'application/pdf'
	)
	}
	it { expect(valid_post).to validate_attachment_size(:picture).less_than(1.megabytes) }

end


 