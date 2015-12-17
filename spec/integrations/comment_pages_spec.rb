require 'rails_helper'

describe "edit" do
	
	it "should display the correct boxes" do
		user = FactoryGirl.create(:user_with_comments)
		comment = user.comments[0]
		login_as_user user
		visit edit_comment_path(comment)
		expect(page).to have_selector("textarea", text: comment.body)
	end

end