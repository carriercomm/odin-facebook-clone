require 'rails_helper'

context 'creating a post with an image' do

	it 'allows for creation of post and shows image' do
		body_text = 'Test Body'
		user = FactoryGirl.create(:user)
		login_as_user(user)
		visit new_user_post_path(user)
		fill_in 'Body', with: body_text
		attach_file 'Picture', Rails.root.join('spec', 'support', 'test.jpg')
		click_button 'Create Post'

		expect(page).to have_text(body_text)
		expect(page).to have_selector("img[@src*='test.jpg']")

	end	

end