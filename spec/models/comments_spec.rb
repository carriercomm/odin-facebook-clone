require 'rails_helper'


describe Comment do 

	let(:user) 	{ FactoryGirl.create(:user) }
	let(:post) { FactoryGirl.create(:post, :user_id => user.id)}
	let(:valid_comment) { FactoryGirl.create(:comment, body: "Comment body!", user_id: user.id, post_id: post.id)}

	it 'creates a comment' do
		expect{valid_comment}.to change{described_class.all.count}.by(1)
	end

	it 'will not allow missing user' do
		comment = described_class.new(body: "Test copy", post_id: post.id)
		expect(comment.valid?).to eq(false)
	end

	it 'will not allow missing body' do
		comment = described_class.new(user_id: user.id, post_id: post.id)
		expect(comment.valid?).to eq(false)
	end

	it 'will not allow missing post' do
		comment = described_class.new(user_id: user.id, body: "Test copy")
		expect(comment.valid?).to eq(false)
	end

end